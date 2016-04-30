--
-- Author: HLZ
-- Date: 2016-01-07 20:21:58
-- 玩家基本信息类

PlayerBaseInfo = class("PlayerBaseInfo")

function PlayerBaseInfo:ctor( )
	self.playerName = ""

	--玩家基本属性数值
	--[[
        基础一级属性：
                     
                     速度
                     进化值
                     饱食度
	--]]
	self.powerValue = 0
	self.speedValue = 3 
	self.energyValue = 0
end

--设置当前使用的怪兽属性
function PlayerBaseInfo:setMonsterData( data )
    
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

--从服务器拿去到的玩家信息
function PlayerBaseInfo:setPlayerBaseInfo(data)

end

function PlayerBaseInfo:getPlayerPowerValue()
	return self.powerValue
end

function PlayerBaseInfo:getPlayerSpeedValue()
	return self.speedValue
end

function PlayerBaseInfo:getPlayerEnergyValue()
	return self.energyValue
end



function PlayerBaseInfo:getMonsterNowSatiation(  )
	return self.nowSatiation
end

function PlayerBaseInfo:getMonsterNowEvolution(  )
	return self.nowEvolution
end

function PlayerBaseInfo:setMonsterNowSatiation(satiation)
	self.nowSatiation = satiation
end

function PlayerBaseInfo:setMonsterNowEvolution(evolution)
	self.nowEvolution = evolution
end

function PlayerBaseInfo:getMonsterID(  )
	return self.id
end

function PlayerBaseInfo:getMonsterName(  )
	return self.name
end

function PlayerBaseInfo:getMonsterLevel(  )
	return self.level
end

function PlayerBaseInfo:getMonsterResName(  )
	return self.resName
end

function PlayerBaseInfo:getMonsterAnimName(  )
	return self.animName
end

function PlayerBaseInfo:getMonsterDesc(  )
	return self.desc
end

function PlayerBaseInfo:getMonsterIcon(  )
	return self.icon
end

function PlayerBaseInfo:getMonsterDevourSkillID(  )
	return self.devourSkillID
end

function PlayerBaseInfo:getMonsterDetectSkillID(  )
	return self.detectSkillID
end

function PlayerBaseInfo:getMonsterExclusiveSkillID(  )
	return self.exclusiveSkillID
end

function PlayerBaseInfo:getMonsterSatiation(  )
	return self.satiation
end

function PlayerBaseInfo:getMonsterEvolution(  )
	return self.evolution
end

return PlayerBaseInfo


