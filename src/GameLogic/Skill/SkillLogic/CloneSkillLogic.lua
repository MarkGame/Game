--
-- Author: HLZ
-- Date: 2016-05-19 19:36:00
-- 分身技能的逻辑
-- 
local CloneSkillLogic = class("CloneSkillLogic",mtCommonSkillLogic())
CloneSkillLogic.__index = CloneSkillLogic

-- 创建技能对象

function CloneSkillLogic.createSkill(data)
    local skillLogic = CloneSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--单独逻辑
function CloneSkillLogic:launch(monster)
	local targetMonster = self:getTargetMonster(monster)
   
   if targetMonster then 
      
   else 
      print("目标怪兽不存在")
   end
end
end


return CloneSkillLogic