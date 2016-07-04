--
-- Author: HLZ
-- Date: 2016-01-07 20:20:33
-- 怪兽信息管理类
--

--[[
    希望 怪兽这一类的 最好能写一个通用的方法 多根据读表去创造 
    而不是 每一种都去创建一个类
]]

local MonsterMgr = class("MonsterMgr")
MonsterMgr.__index = MonsterMgr

function MonsterMgr:getInstance(  )
    if self.instance == nil then
        self.instance = MonsterMgr.new()
    end
    return self.instance
end

function MonsterMgr:ctor()

end

--生成怪兽
function MonsterMgr:createMonster( data )
	local monsterLogic = mtCommonMonsterLogic().new(data)
    
    local monsterView = mtMonsterView().new(monsterLogic)
    
    --设置怪兽的出生时间 （其实这些都是需要服务器来发的，目前先本地写）
    local birthTime = mtTimeMgr():getCurTime()
    monsterLogic:setMonsterBirthTime(birthTime)
    
    return monsterView
end

--删除怪兽
function MonsterMgr:removeMonster(monster)
	
end

return MonsterMgr