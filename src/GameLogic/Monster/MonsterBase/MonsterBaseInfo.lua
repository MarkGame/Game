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
    self.maxSatiation = data.MaxSatiation
    self.maxEvolution = data.MaxEvolution
    self.hungry = data.Hungry
    self.velocity = data.Velocity
    --及时属性
    --当前的 饱食度和进化值
    self.nowSatiation = data.MaxSatiation
    self.nowEvolution = 0
    self.nowVelocity = data.Velocity
    self.nowLevel = data.Level

    --出生时间
    self.birthTime = 0

    --是否 是主怪 不是则为中立怪
    self.isMainMonster = false 

end

--从服务器拿去到的信息
function MonsterBaseInfo:setMonsterBaseInfo(data)

end


function MonsterBaseInfo:setIsMainMonster( flag )
	self.isMainMonster = true
end

function MonsterBaseInfo:getIsMainMonster(  )
	return self.isMainMonster
end

function MonsterBaseInfo:setBirthTime( time )
	self.birthTime = time
    print("BirthTime :"..self.birthTime)
end

function MonsterBaseInfo:getBirthTime(  )
	return self.birthTime 
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

function MonsterBaseInfo:getInitMonsterLevel(  )
	return self.level
end

function MonsterBaseInfo:getMonsterLevel(  )
    return self.nowLevel
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

function MonsterBaseInfo:getMonsterMaxSatiation(  )
	return self.maxSatiation
end

function MonsterBaseInfo:getMonsterMaxEvolution(  )
	return self.maxEvolution
end

function MonsterBaseInfo:getMonsterHungry(  )
    return self.hungry
end

--初始化怪兽移速
function MonsterBaseInfo:initMonsterVelocity(  )
    self.nowVelocity = self.velocity
end

function MonsterBaseInfo:setMonsterVelocity(velocity)
    self.nowVelocity = velocity
end

function MonsterBaseInfo:getMonsterVelocity( )
    return self.nowVelocity
end

function MonsterBaseInfo:getMonsterSatiationPercent(  )
    return math.min(math.floor(self.nowSatiation/self.maxSatiation*100),100) 
end

function MonsterBaseInfo:getMonsterEvolutionPercent(  )
    return math.min(math.floor(self.nowEvolution/self.maxEvolution*100),100)
end


return MonsterBaseInfo