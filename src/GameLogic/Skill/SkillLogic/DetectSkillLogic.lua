--
-- Author: HLZ
-- Date: 2016-05-19 00:13:00
-- 探测技能的逻辑
-- 
local DetectSkillLogic = class("DetectSkillLogic",mtCommonSkillLogic())
DetectSkillLogic.__index = DetectSkillLogic

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function DetectSkillLogic.createSkill(data)
    local skillLogic = DetectSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

return DetectSkillLogic