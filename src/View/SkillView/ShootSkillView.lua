--
-- Author: HLZ
-- Date: 2016-08-29 15:35:00
-- 喷射技能的视图
-- 
local ShootSkillView = class("ShootSkillView",mtCommonSkillView())
ShootSkillView.__index            = ShootSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function ShootSkillView.createSkill(data)
    local skillView = ShootSkillView.new()
    skillView:init(data)
    return skillView
end

function ShootSkillView:launch()
	
	self:initBullet(600)

end

return ShootSkillView