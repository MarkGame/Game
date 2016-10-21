--
-- Author: HLZ
-- Date: 2016-05-19 19:36:00
-- 分身技能的视图
-- 
local CloneSkillView = class("CloneSkillView",mtCommonSkillView())
CloneSkillView.__index            = CloneSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function CloneSkillView.createSkill(data)
    local skillView = CloneSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
--加速是对自己使用的
function CloneSkillView:launch(monster,index) 

   
end

function CloneSkillView:removeSkill( )

end

return CloneSkillView
