--
-- Author: HLZ
-- Date: 2016-05-19 19:33:00
-- 闪耀技能的逻辑
-- 
local ShineSkillLogic = class("ShineSkillLogic",mtCommonSkillLogic())
ShineSkillLogic.__index = ShineSkillLogic

-- 创建技能对象

function ShineSkillLogic.createSkill(data)
    local skillLogic = ShineSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--单独逻辑
function ShineSkillLogic:launch(monster)
	local targetMonster = self:getTargetMonster(monster)
   
   if targetMonster then 
      
   else 
      print("目标怪兽不存在")
   end
end


return ShineSkillLogic