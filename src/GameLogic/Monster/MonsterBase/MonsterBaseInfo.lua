--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 怪兽的基本结构体

local MonsterBaseInfo = class("MonsterBaseInfo")

function MonsterBaseInfo:ctor( data )
    
    --表格的基本属性
    self.id = data.ID
    self.name = data.Name
    self.level = data.Level
    self.resName = data.ResName
    self.animName = data.AnimName
    self.desc = data.Desc
    self.icon = data.Icon
    self.devourSkillID = data.DevourSkillID
    self.detectSkillID = data.DetectSkillID
    self.exclusiveSkillID = data.ExclusiveSkillID
    self.satiation = data.Satiation
    self.evolution = data.Evolution

    self.nowSatiation = 100
    self.nowEvolution = 0
end

function MonsterBaseInfo:getMonsterNowSatiation(  )
	return self.nowSatiation
end

function MonsterBaseInfo:getMonsterNowEvolution(  )
	return self.nowEvolution
end

function MonsterBaseInfo:setMonsterNowSatiation(satiation)
	self.nowSatiation = satiation
end

function MonsterBaseInfo:setMonsterNowEvolution(evolution)
	self.nowEvolution = evolution
end

function MonsterBaseInfo:getMonsterID(  )
	return self.id
end

function MonsterBaseInfo:getMonsterName(  )
	return self.name
end

function MonsterBaseInfo:getMonsterLevel(  )
	return self.level
end

function MonsterBaseInfo:getMonsterResName(  )
	return self.resName
end

function MonsterBaseInfo:getMonsterAnimName(  )
	return self.animName
end

function MonsterBaseInfo:getMonsterDesc(  )
	return self.desc
end

function MonsterBaseInfo:getMonsterIcon(  )
	return self.icon
end

function MonsterBaseInfo:getMonsterDevourSkillID(  )
	return self.devourSkillID
end

function MonsterBaseInfo:getMonsterDetectSkillID(  )
	return self.detectSkillID
end

function MonsterBaseInfo:getMonsterExclusiveSkillID(  )
	return self.exclusiveSkillID
end

function MonsterBaseInfo:getMonsterSatiation(  )
	return self.satiation
end

function MonsterBaseInfo:getMonsterEvolution(  )
	return self.evolution
end

return MonsterBaseInfo