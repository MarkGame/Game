local Component = require("Component")

local HumanBehaviorSM = class("HumanBehaviorSM",Component)


function HumanBehaviorSM:ctor( ... )
	-- body
	self.moveDirection = cc.p(0,0)
	return HumanBehaviorSM.super.ctor(self,...)
end


function HumanBehaviorSM:onBind_()
    self.fsm = StateMachine.new()

    self.fsm:setupState({
    --初始状态
    --希望这里能够读表
    --正在配置表，等待test
    initial = "Idle",
    events = {
              {name = "toIdle", from = {"Move","Skill"}, to = "Idle"},
              {name = "toMove", from = {"Idle","Skill"}, to = "Move"},
              {name = "toSkill", from = {"Idle","Move"}, to = "Skill"},
              {name = "toDie", from = {"Idle","Move","Skill"},to= "Die"}
          },
  })
end



function HumanBehaviorSM:update(delta)
    self.fsm:getState():update(delta)
end 

function HumanBehaviorSM:unBind_()
end


return HumanBehaviorSM