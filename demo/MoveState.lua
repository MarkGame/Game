local State = require "State"

local MoveState = class("MoveState",State)

function MoveState:onEnter(event)
	self.target_:playAnim("MOVE")
end

function MoveState:checkCanMove()
end

function MoveState:update(delta)
	local actionData = self.target_:getAction()
	if actionData.Type == MOVE then
		self.target_:setPosition(...)
	end
end

return MoveState