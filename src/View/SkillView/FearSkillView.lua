--
-- Author: HLZ
-- Date: 2016-05-19 19:35:00
-- 恐惧技能的逻辑
-- 
local FearSkillView = class("FearSkillView",mtCommonSkillView())
FearSkillView.__index            = FearSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function FearSkillView.createSkill(data)
    local skillView = FearSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
function FearSkillView:launch(monster,index) 

   
end

function FearSkillView:removeSkill( )

end

return FearSkillView