local Component = require("Component")

local NetworkActionComponent = class("NetworkActionComponent",Component)


function NetworkActionComponent:ctor( ... )
	-- body
	self.moveDirection = cc.p(0,0)
	return NetworkActionComponent.super.ctor(self,...)
end


function NetworkActionComponent:onBind_()
end



function NetworkActionComponent:update(delta)
    -- 模拟从网络接收到数据
    local _type = math.rand(2)
    if _type == 1 then
        self.target:pushAction(CreateActionData(ActionType.MOVE,cc.p(1,0)))
    elseif _type == 2 then
        self.target:pushAction(CreateActionData(ActionType.SKILL,1))
    end
end 

function NetworkActionComponent:unBind_()
end


return NetworkActionComponent