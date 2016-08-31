--
-- Author: HLZ
-- Date: 2016-05-19 00:10:31
-- 吞噬技能的逻辑
-- 
local DevourSkillView = class("DevourSkillView",mtCommonSkillView())
DevourSkillView.__index            = DevourSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function DevourSkillView.createSkill(data)
    local skillView = DevourSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
function DevourSkillView:launch(monster,index) 

   
end

function DevourSkillView:removeSkill( )

end

return DevourSkillView