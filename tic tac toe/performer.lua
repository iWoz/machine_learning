require "player"

Performer = class("Performer", Singleton)

function Performer:ctor()
	self.board = nil
	self.playedNum = 0
	self.winedNum = 0
	self.lostNum = 0
	self.drawedNum = 0
end

-- 开始新的训练
function Performer:startTrain()
	local trainer1 = Player:create(SIDE_X, true)
	local trainer2 = Player:create(SIDE_O, true)
	local moveIdx = 0
	local trainValue = 0
	self.board = self:genNewBoard()

	while not self:isGameOver() do
		local preBoard = clone(self.board)
		if moveIdx % 2 == 0 then
			self.board, trainValue = trainer1:makeAMove(self.board)
			Trainer:getInstance():addTrainPair(trainer1, preBoard, trainValue)
		else
			self.board, trainValue = trainer2:makeAMove(self.board)
			-- Trainer:getInstance():addTrainPair(trainer2, preBoard, trainValue)
		end
		moveIdx = moveIdx + 1
	end

	local xl, nullNum = getBoardParams(self.board, trainer1.side)
	if xl[1] >= 1 then
		Trainer:getInstance():addTrainPair(trainer1, self.board, VALUE_WINED)
		-- Trainer:getInstance():addTrainPair(trainer2, self.board, VALUE_LOST)
	elseif xl[2] >= 1 then
		Trainer:getInstance():addTrainPair(trainer1, self.board, VALUE_LOST)
		-- Trainer:getInstance():addTrainPair(trainer2, self.board, VALUE_WINED)
	else
		Trainer:getInstance():addTrainPair(trainer1, self.board, VALUE_DRAW)
		-- Trainer:getInstance():addTrainPair(trainer2, self.board, VALUE_DRAW)
	end

	Trainer:getInstance():startTrain()

end

-- 生成新局面
function Performer:genNewBoard()
	return
		{
			{SIDE_NULL, SIDE_NULL, SIDE_NULL,},
			{SIDE_NULL, SIDE_NULL, SIDE_NULL,},
			{SIDE_NULL, SIDE_NULL, SIDE_NULL,},
		}
end

-- 判断是否终局
function Performer:isGameOver(board)
	board = board or self.board
	if not board then
		return true
	end
	local xl, nullNum = getBoardParams(board, SIDE_X)
	return xl[1] >= 1 or xl[2] >= 1 or nullNum == 0
end
