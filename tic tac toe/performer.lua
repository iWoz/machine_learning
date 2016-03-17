require "player"

Performer = class("Performer", Singleton)

function Performer:ctor()
	self.board = nil
	self.playedNum = 0
	self.winedNum = 0
	self.lostNum = 0
	self.drawedNum = 0
end

-- 开始新的对局
function Performer:startAGame()
	local playerTrainer = Player:create(SIDE_X, true)
	local playerTester = Player:create(SIDE_O)
	playerTrainer:setOpponent(playerTester)
	playerTester:setOpponent(playerTrainer)

	local moveIdx = 0
	self.board = self:genNewBoard()
	print("start ======")
	-- printBoard(self.board)
	local trainValue = 0
	while not self:isGameOver() do
		if moveIdx % 2 == 0 then
			self.board, trainValue = playerTrainer:makeAMove(self.board)
			Trainer:getInstance():addTrainPair(playerTrainer, self.board, trainValue)
		else
			self.board, trainValue = playerTester:makeAMove(self.board)
		end
		moveIdx = moveIdx + 1
		-- printBoard(self.board)
	end
	-- printBoard(self.board)
	self.playedNum = self.playedNum + 1
	local xl, nullNum = getBoardParams(self.board, playerTrainer.side)
	if xl[3] >= 1 then
		self.winedNum = self.winedNum + 1
	elseif xl[4] >= 1 then
		self.lostNum = self.lostNum + 1
	else
		self.drawedNum = self.drawedNum + 1
	end
	print(string.format("Win Rate:%.2f, Lost Rate:%.2f, Draw Rate:%.2f", self.winedNum / self.playedNum, self.lostNum / self.playedNum, self.drawedNum / self.playedNum))
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
	return xl[3] >= 1 or xl[4] >= 1 or nullNum == 0
end
