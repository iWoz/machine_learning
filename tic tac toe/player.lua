require "trainer"

Player = class("Player")

function Player:ctor(side, isTrainer)
	self.side = side
	self.isTrainer = isTrainer

end

-- 设置对手
function Player:setOpponent(opponent)
	self.opponent = opponent
end

-- 针对当前盘面，做出下一步棋的落子选择
function Player:makeAMove(board)
	
end

-- 盘面状态函数
function Player:getBoardParams(board)
	local side_x_1 = 0
	local side_x_2 = 0
	local side_o_1 = 0
	local side_o_2 = 0

	local function account(dic)
		if dic[SIDE_X] == 3 then
			side_x_2 = side_x_2 + 1
		elseif dic[SIDE_O] == 3 then
			side_o_2 = side_o_2 + 1 
		elseif dic[SIDE_X] == 2 and dic[SIDE_O] == 0 then
			side_x_1 = side_x_1 + 1
		elseif dic[SIDE_O] == 2 and dic[SIDE_X] == 0 then
			side_o_1 = side_o_1 + 1
		end
	end
	-- 统计每一行
	for i=1,3 do
		local dic = {[SIDE_X]=0, [SIDE_O]=0, [SIDE_NULL]=0}
		for j=1,3 do
			dic[board[i][j]] = dic[board[i][j]] + 1
		end
		account(dic)
	end
	-- 统计每一列
	for i=1,3 do
		local dic = {[SIDE_X]=0, [SIDE_O]=0, [SIDE_NULL]=0}
		for j=1,3 do
			dic[board[j][i]] = dic[board[j][i]] + 1
		end
		account(dic)
	end
	-- 统计对角线
	local diagonalPair = 
	{
		{{1,1}, {2,2}, {3,3}},
		{{1,3}, {2,2}, {3,1}},
	}
	for _,pairList in ipairs(diagonalPair) do
		local dic = {[SIDE_X]=0, [SIDE_O]=0, [SIDE_NULL]=0}
		for _,pair in ipairs(pairList) do
			local bi = board[pair[1]][pair[2]]
			dic[bi] = dic[bi] + 1
		end
		account(dic)
	end

	if self.side == SIDE_X then
		return {side_x_1, side_o_1, side_x_2, side_o_2}
	elseif self.side == SIDE_O then
		return {side_o_1, side_x_1, side_o_2, side_x_2}
	end
end

-- 盘面估值函数
function Player:getBoardValue(board, side)
	local xl = getBoardParams(board, side)
	if self.isTrainer then
		local trainer = Trainer:getInstance()
		return trainer.w0 + xl[1] * trainer.w1 + xl[2] * trainer.w2 + xl[3] * trainer.w3 + xl[4] * trainer.w4
	else
		return FIXED_W0 + xl[1] * FIXED_W1 + xl[2] * FIXED_W2 + xl[3] * FIXED_W3 + xl[4] * FIXED_W4
	end
end
