--
-- Author: HLZ
-- Date: 2016-08-29 15:35:00
-- 喷射技能的逻辑
-- 
local ShootSkillLogic = class("ShootSkillLogic",mtCommonSkillLogic())
ShootSkillLogic.__index = ShootSkillLogic

-- 创建技能对象

function ShootSkillLogic.createSkill(data)
    local skillLogic = ShootSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--单独逻辑
--[[
    非指向性技能
]]
function ShootSkillLogic:launch()
	
	local bullet = self:createBullet()
    --self:shootBullet(bullet)
end


return ShootSkillLogic