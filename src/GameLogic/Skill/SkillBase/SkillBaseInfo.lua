--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 技能的基本结构体
--

local SkillBaseInfo = class("SkillBaseInfo")

function SkillBaseInfo:ctor( data )
    --表格的基本属性
    self.id = data.ID
    self.name = data.Name
    self.desc = data.Desc
    self.stepLevel = data.StepLevel
    self.level = data.Level
    self.skillType = data.SkillType
    self.skillRangeType = data.SkillRangeType
    self.skillRange = data.SkillRange
    self.resName = data.ResName
    self.animName = data.AnimName
    self.icon = data.Icon
    self.buffID = data.BuffID
    self.skillCD = data.CD
    
end

function SkillBaseInfo:getSkillID(  )
	return self.id
end

function SkillBaseInfo:getSkillName(  )
	return self.name
end

function SkillBaseInfo:getSkillDesc(  )
	return self.desc
end

function SkillBaseInfo:getSkillStepLevel(  )
	return self.stepLevel
end

function SkillBaseInfo:getSkillLevel(  )
	return self.level
end

function SkillBaseInfo:getSkillType(  )
	return self.skillType
end

function SkillBaseInfo:getSkillRangeType(  )
	return self.skillRangeType
end

function SkillBaseInfo:getSkillRange(  )
	return self.skillRange
end

function SkillBaseInfo:getSkillResName(  )
	return self.resName
end

function SkillBaseInfo:getSkillAnimName(  )
	return self.animName
end

function SkillBaseInfo:getSkillIcon(  )
	return self.icon
end

function SkillBaseInfo:getSkillBuffID(  )
	return self.buffID
end

function SkillBaseInfo:getSkillCD(  )
	return self.skillCD
end

return SkillBaseInfo