--
-- Author: HLZ
-- Date: 2016-05-19 19:33:00
-- 隐身技能的逻辑
-- 
local InvisibleSkillView = class("InvisibleSkillView",mtCommonSkillView())
InvisibleSkillView.__index            = InvisibleSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function InvisibleSkillView.createSkill(data)
    local skillView = InvisibleSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
function InvisibleSkillView:launch(monster,index) 

   
end

function InvisibleSkillView:removeSkill( )

end

return InvisibleSkillView