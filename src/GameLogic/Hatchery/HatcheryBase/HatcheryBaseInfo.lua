--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 孵化场的基本结构体

--[[
	孵化阶段	Name
	孵化池ID	PoolID
	战场ID	BattleAreaID
	怪兽ID	MonsterID
	权重	Prob
	怪兽描述	Desc
	最大数量	MaxCount
]]

local HatcheryBaseInfo = class("HatcheryBaseInfo")

function HatcheryBaseInfo:ctor( data )

	self.battleAreaID = mtBattleMgr():getBattleAreaID()
    --获得表格里面的当前战场的 孵化池信息
    self.hatcheryList = g_Config:getData(GameConfig.addConfig["Hatchery"],"BattleAreaID",self.battleAreaID)
    
    self.hatcheryPoolList = {}
    
    self:initHatcheryList()
end

--初始化 孵化场列表
--并根据poolID 来区分数组
function HatcheryBaseInfo:initHatcheryList( )
	for k,v in ipairs(self.hatcheryList) do
		if v then 
           if self.hatcheryPoolList[v.PoolID] == nil then 
           	  self.hatcheryPoolList[v.PoolID] =  {}
           else
              table.insert(self.hatcheryPoolList[v.PoolID],v)
           end
		end 
	end
end

--获得孵化池ID
function HatcheryBaseInfo:getPoolIDByStage( stage )
	local poolID = (self.battleAreaID%100)*1000 + stage
	return poolID
end

--通过当前阶段 获得孵化场信息
function HatcheryBaseInfo:getHatcheryListByStage( stage )
	local poolID = self:getPoolIDByStage(stage)
	if self.hatcheryPoolList[poolID] and #self.hatcheryPoolList[poolID] > 0 then 
	   return self.hatcheryPoolList[poolID]
	else
	   print("配置出错")
	   return nil
	end
end

--获得随机怪兽数组
function HatcheryBaseInfo:getRandomMonsterListByStage(stage)
	local hatcheryPoolList = self:getHatcheryListByStage(stage)
	local randomMonsterList = {}
	--权值总值（一般是10000，可能有误差）
	local totalProb = 0
	for k,v in ipairs(hatcheryPoolList) do
		if v then 
		    local data = {}
			data.minNum = totalProb + 1
			data.maxNum = totalProb + v.Prob
			data.monsterID = v.MonsterID
			data.maxCount = v.MaxCount
	        table.insert(randomMonsterList,data)
	        totalProb = data.maxNum
        end
	end
	return randomMonsterList,totalProb
end

function HatcheryBaseInfo:getNowHatcheryInfo( stage )
	local poolID = self:getPoolIDByStage(stage)
	local hatcheryInfoList = g_Config:getData(GameConfig.addConfig["HatcheryInfo"],"PoolID",poolID)[1]
    return hatcheryInfoList
end

return HatcheryBaseInfo