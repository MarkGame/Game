--
-- Author: HLZ
-- Date: 2016-05-18 20:22:31
-- 加速技能的视图
-- 
local AccelerateSkillView = class("AccelerateSkillView",mtCommonSkillView())
AccelerateSkillView.__index            = AccelerateSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function AccelerateSkillView.createSkill(data)
    local skillView = AccelerateSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
--加速是对自己使用的
function AccelerateSkillView:launch(monster,index) 

   
end

function AccelerateSkillView:removeSkill( )

end


return AccelerateSkillView

