local State = require "State"
local IdleState = class("IdleState",State)

function IdleState:onEnter(event)
	self.target_:playAnim("IDLE")
end

return IdleState