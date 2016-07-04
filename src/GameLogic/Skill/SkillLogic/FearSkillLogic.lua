--
-- Author: HLZ
-- Date: 2016-05-19 19:35:00
-- 恐惧技能的逻辑
-- 
local FearSkillLogic = class("FearSkillLogic",mtCommonSkillLogic())
FearSkillLogic.__index = FearSkillLogic

-- 创建技能对象

function FearSkillLogic.createSkill(data)
    local skillLogic = FearSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--单独逻辑
function FearSkillLogic:launch(monster)
    local targetMonster = self:getTargetMonster(monster)
   
    if targetMonster then 
      
    else 
       print("目标怪兽不存在")
    end
end


return FearSkillLogic