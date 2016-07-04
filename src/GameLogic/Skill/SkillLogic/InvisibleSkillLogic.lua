--
-- Author: HLZ
-- Date: 2016-05-19 19:33:00
-- 隐身技能的逻辑
-- 
local InvisibleSkillLogic = class("InvisibleSkillLogic",mtCommonSkillLogic())
InvisibleSkillLogic.__index = InvisibleSkillLogic

-- 创建技能对象

function InvisibleSkillLogic.createSkill(data)
    local skillLogic = InvisibleSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--单独逻辑
function InvisibleSkillLogic:launch(monster)
	local targetMonster = self:getTargetMonster(monster)
   
   if targetMonster then 
      
   else 
      print("目标怪兽不存在")
   end
end

return InvisibleSkillLogic