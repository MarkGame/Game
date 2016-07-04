--
-- Author: HLZ
-- Date: 2016-05-19 00:10:31
-- 吞噬技能的逻辑
-- 
local DevourSkillLogic = class("DevourSkillLogic",mtCommonSkillLogic())
DevourSkillLogic.__index = DevourSkillLogic

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function DevourSkillLogic.createSkill(data)
    local skillLogic = DevourSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

return DevourSkillLogic