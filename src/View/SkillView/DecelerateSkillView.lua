--
-- Author: HLZ
-- Date: 2016-05-18 20:21:31
-- 减速技能的视图
-- 
local DecelerateSkillView = class("DecelerateSkillView",mtCommonSkillView())
DecelerateSkillView.__index            = DecelerateSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function DecelerateSkillView.createSkill(data)
    local skillView = DecelerateSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
--加速是对自己使用的
function DecelerateSkillView:launch(monster,index) 

   
end

function DecelerateSkillView:removeSkill( )

end

return DecelerateSkillView