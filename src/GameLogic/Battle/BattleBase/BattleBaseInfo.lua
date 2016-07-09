--
-- Author: HLZ
-- Date: 2016-07-07 19:52:00
-- 战场的基本结构体

local BattleBaseInfo = class("BattleBaseInfo")

function BattleBaseInfo:ctor( data )
    
    --表格的基本属性
    self.hatcheryCount = data.HatcheryCount
    self.hatcheryPosTable = data.HatcheryPosTable
    self.initHatchPosTable = data.InitHatchPosTable
    self.waitTime = data.WaitTime
    
    --孵化场的坐标数组
    self.hatcheryPosList = {}
    --初始孵化点的坐标数组
    self.initHatchPosList = {}

    --孵化场基本信息数组
    self.hatcheryInfoList = {}

end
 
--用于服务器传递数据
function BattleBaseInfo:initData( data )
	-- body
end

--获取孵化场的数量
function BattleBaseInfo:getHatcheryCount(  )
	return self.hatcheryCount
end
--获取孵化场的坐标数组
function BattleBaseInfo:getHatcheryPosList(  )
	--如果已经获取过，则直接拿
	if self.hatcheryPosList and #self.hatcheryPosList > 0 then 
    else
		if self.hatcheryPosTable then 
		   local strTable = string.split(self.hatcheryPosTable,"|")
		   for k,v in ipairs(strTable) do
		       if v then 
		       	  local posTable = string.split(v,",")
		       	  local posX = tonumber(posTable[1])
		       	  local posY = tonumber(posTable[2])
		       	  local pos = cc.p(posX,posY)
		       	  table.insert(self.hatcheryPosList,pos)
		       end 
		   end 
		end
	end
	return self.hatcheryPosList
end

--获取初始怪兽孵化点的坐标数组
function BattleBaseInfo:getInitHatchPosList(  )
	--如果已经获取过，则直接拿
	if self.initHatchPosList and #self.initHatchPosList > 0 then 
    else
		if self.initHatchPosTable then 
		   local strTable = string.split(self.initHatchPosTable,"|")
		   for k,v in ipairs(strTable) do
		       if v then 
		       	  local posTable = string.split(v,",")
		       	  local posX = tonumber(posTable[1])
		       	  local posY = tonumber(posTable[2])
		       	  local pos = cc.p(posX,posY)
		       	  table.insert(self.initHatchPosList,pos)
		       end 
		   end 
		end
	end
	return self.initHatchPosList
end

function BattleBaseInfo:getHatcheryInfoList(  )
	-- body
end

--获取当前场景等待时间
function BattleBaseInfo:getWaitTime(  )
	return self.waitTime
end

return BattleBaseInfo