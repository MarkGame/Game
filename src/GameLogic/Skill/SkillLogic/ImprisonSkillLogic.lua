--
-- Author: HLZ
-- Date: 2016-05-19 19:31:00
-- 禁锢技能的逻辑
-- 
local ImprisonSkillLogic = class("ImprisonSkillLogic",mtCommonSkillLogic())
ImprisonSkillLogic.__index = ImprisonSkillLogic

-- 创建技能对象

function ImprisonSkillLogic.createSkill(data)
    local skillLogic = ImprisonSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--发动技能 
--让敌人无法移动 上一个禁锢的状态 或者 是将速度降为0 
--两者二选一 看看哪种比较方便
function ImprisonSkillLogic:launch(monster)
   local targetMonster = self:getTargetMonster(monster)
   
   if targetMonster then 
      
   else 
      print("目标怪兽不存在")
   end  
end

return ImprisonSkillLogic