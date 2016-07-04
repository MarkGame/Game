--
-- Author: HLZ
-- Date: 2016-05-19 19:31:00
-- 传送技能的逻辑
-- 
local TransferSkillLogic = class("TransferSkillLogic",mtCommonSkillLogic())
TransferSkillLogic.__index = TransferSkillLogic

-- 创建技能对象

function TransferSkillLogic.createSkill(data)
    local skillLogic = TransferSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--单独逻辑
function TransferSkillLogic:launch(monster)
	local targetMonster = self:getTargetMonster(monster)
   
   if targetMonster then 
      
   else 
      print("目标怪兽不存在")
   end
end

return TransferSkillLogic