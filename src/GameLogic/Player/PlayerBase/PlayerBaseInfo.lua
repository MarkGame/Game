--
-- Author: HLZ
-- Date: 2016-01-07 20:21:58
-- 玩家基本信息类

local PlayerBaseInfo = class("PlayerBaseInfo")

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

--设置当前使用的怪兽属性 转移到通用的 MonsterBaseInfo 里面去了 
function PlayerBaseInfo:setMonsterData( data )


end

return PlayerBaseInfo


