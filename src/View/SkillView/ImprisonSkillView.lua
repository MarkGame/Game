--
-- Author: HLZ
-- Date: 2016-05-19 19:31:00
-- 禁锢技能的视图
-- 
local ImprisonSkillView = class("ImprisonSkillView",mtCommonSkillView())
ImprisonSkillView.__index            = ImprisonSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function ImprisonSkillView.createSkill(data)
    local skillView = ImprisonSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
function ImprisonSkillView:launch(monster,index) 

   
end

function ImprisonSkillView:removeSkill( )

end

return ImprisonSkillView