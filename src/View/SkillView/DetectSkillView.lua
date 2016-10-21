--
-- Author: HLZ
-- Date: 2016-05-19 00:13:00
-- 探测技能的视图
-- 
local DetectSkillView = class("DetectSkillView",mtCommonSkillView())
DetectSkillView.__index            = DetectSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function DetectSkillView.createSkill(data)
    local skillView = DetectSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
--加速是对自己使用的
function DetectSkillView:launch(monster,index) 

   
end

function DetectSkillView:removeSkill( )

end

return DetectSkillView