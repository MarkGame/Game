--
-- Author: HLZ
-- Date: 2016-05-19 19:33:00
-- 闪耀技能的视图
-- 
local ShineSkillView = class("ShineSkillView",mtCommonSkillView())
ShineSkillView.__index            = ShineSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function ShineSkillView.createSkill(data)
    local skillView = ShineSkillView.new()
    skillView:init(data)
    return skillView
end

--单独逻辑
function ShineSkillView:launch(monster,index) 

   
end

function ShineSkillView:removeSkill( )

end


return ShineSkillView