require "trainer"
require "utils"

Player = class("Player")
local pid = 0

function Player:ctor(side, isTrainer)
	self.side = side
	if side == SIDE_X then
		self.opponentSide = SIDE_O
	else
		self.opponentSide = SIDE_X
	end
	self.isTrainer = isTrainer
	pid = pid + 1
	self.id = pid
end

-- 针对当前盘面，做出下一步棋的落子选择
function Player:makeAMove(board)
	local moveList = {}
	for i=1,3 do
		for j=1,3 do
			if board[i][j] == SIDE_NULL then
				moveList[#moveList+1] = {i,j,0}
			end
		end
	end
	-- 随机化，不受行列顺序限制
	shuffleTable(moveList)

	for _,move in ipairs(moveList) do
		local newBoard = clone(board)
		newBoard[move[1]][move[2]] = self.side
		move[4] = newBoard
		local successorBoard = self:getSuccessorBoard(newBoard)
		move[3] = self:getBoardValue(successorBoard)
	end
	table.sort(moveList, function(pre, post)
		return pre[3] > post[3]
	end)
	return moveList[1][4], moveList[1][3]
end

-- 针对当前盘面，模拟对手下一步之后的盘面
function Player:getSuccessorBoard(board)
	if Performer:getInstance():isGameOver(board) then
		return board
	end

	local moveList = {}
	for i=1,3 do
		for j=1,3 do
			if board[i][j] == SIDE_NULL then
				moveList[#moveList+1] = {i,j,0}
			end
		end
	end
	-- 随机化，不受行列顺序限制
	shuffleTable(moveList)

	for _,move in ipairs(moveList) do
		local newBoard = clone(board)
		newBoard[move[1]][move[2]] = self.opponentSide
		move[4] = newBoard
		-- 依赖自己对对手下一步的估计来模拟对手的下一步落子
		move[3] = self:getBoardValue(newBoard, self.opponentSide)
	end
	table.sort(moveList, function(pre, post)
		return pre[3] > post[3]
	end)
	return moveList[1][4]
end

-- 盘面状态函数
function Player:getBoardParams(board, side)
	side = side or self.side
	return getBoardParams(board, side)
end

-- 盘面估值函数
function Player:getBoardValue(board, side, isTrainer)
	side = side or self.side
	isTrainer = isTrainer or self.isTrainer
	local xl, nullNum = self:getBoardParams(board, side)
	if xl[1] >= 1 then
		return VALUE_WINED
	elseif xl[2] >= 1 then
		return VALUE_LOST
	elseif nullNum == 0 then
		return VALUE_DRAW
	end
	if isTrainer then
		local trainer = Trainer:getInstance()
		return trainer.w0 + xl[1] * trainer.w1 + xl[2] * trainer.w2 + xl[3] * trainer.w3 + xl[4] * trainer.w4
	else
		return FIXED_W0 + xl[1] * FIXED_W1 + xl[2] * FIXED_W2 + xl[3] * FIXED_W3 + xl[4] * FIXED_W4
	end
end
