local Component = require("Component")

local AIComponent = class("AIComponent",Component)


local DO_IDLE = 1
local DO_MOVE = 2
local DO_SEARCH = 3

function AIComponent:ctor( ... )
	-- body
	return AIComponent.super.ctor(self,...)
end


function AIComponent:onBind_()
end



function AIComponent:update(delta)
    local action = math.random(3)
    local currState = self.target_:getCurrState()
    if action == 1 then
    elseif action == 2 then
    elseif action == 3 then
    end
end 

function AIComponent:unBind_()
end


return AIComponent