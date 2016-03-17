require "functions"
require "const"

Trainer = class("Trainer", Singleton)

function Trainer:ctor()
	-- 需要训练的权值
	self.w0 = FIXED_W0 -- 常数权重
	self.w1 = FIXED_W1 -- 己方二连数权重
	self.w2 = FIXED_W2 -- 对方二连数权重
	self.w3 = FIXED_W3 -- 己方三连数权重
	self.w4 = FIXED_W4 -- 对手三连数权重
	-- 训练样本集
	self.trainPairs = {}
	self.updateStep = UPDATE_STEP
end

function Trainer:updateSingleWeight(player, board, trainValue)
	local xl = player:getBoardParams(board)
	for i,xi in ipairs(xl) do
		local estimateValue = self.w0 + xl[1] * self.w1 + xl[2] * self.w2 + xl[3] * self.w3 + xl[4] * self.w4
		self["w"..i] = self["w"..i] + self.updateStep * (trainValue - estimateValue) * xi
	end
end

function Trainer:addTrainPair(player, board, trainValue)
	if not self.trainPairs[player] then
		self.trainPairs[player] = {}
	end
	table.insert(self.trainPairs[player], {board, trainValue})
end

function Trainer:startTrain()
	print("before train:", self.w0, self.w1, self.w2, self.w3, self.w4)
	for player,trainSet in pairs(self.trainPairs) do
		for _,trainPair in pairs(trainSet) do
			self:updateSingleWeight(player, trainPair[1], trainPair[2])
		end
		self.trainPairs[player] = nil
	end
	print("after train:", self.w0, self.w1, self.w2, self.w3, self.w4)
end
