require "player"

Performer = class("Performer", Singleton)

function Performer:ctor()

end

function Performer:startAGame()
	local playerTrainer = Player:create(SIDE_X, true)
	local playerTester = Player:create(SIDE_O)
end
