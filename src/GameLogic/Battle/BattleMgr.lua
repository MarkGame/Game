--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 战斗场景信息管理器

--[[
    需要处理 当前进化阶段 
    整个 游戏本体流程的大主管

]]

--local SkillDetect = require("GameLogic.Skill.SkillDetect")

local BattleMgr = class("BattleMgr")
--BattleMgr.__index = BattleMgr

function BattleMgr:getInstance(  )
    if self.instance == nil then
        self.instance = BattleMgr.new()
    end
    return self.instance
end

function BattleMgr:ctor()
  --游戏开始的时候初始化 数据  
  --self:initData()

end

--初始化 数据 
function BattleMgr:initData(data)
  	--当前的阶段  0 init 1 level1 2 :level2 3 :level3 4 :end
 
  	self.battleStage = BattleStage.level1
    self.startTime = mtTimeMgr():getCurTime()
    
  
    --当前存活的怪兽表
    --包含 主怪 中立怪 敌方怪
    self.monsterList = {}
    --孵化出的怪兽（保护已经死亡，消失的）
    --根据怪兽的ID 来存放
    self.allMonsterList = {}
    --当前激活的孵化场
    self.hatcheryList = {}
    
    self.battleScene = data.scene

    --当前战场ID
    self.battleAreaID = 101 --data.battleAreaID


    --记录怪兽行为日志的ID
    self.monsterLogID = 0
    
    --怪兽行为日志的怪兽ID
    self.monsterLogMonsterID = {}

    self.monsterLogList = {}

    self:initBattleInfo()


    --开始计时器
    self:startUpdateBattle()

end

function BattleMgr:initBattleInfo( )
    local battleInfo = g_Config:getData("Battle","BattleAreaID",self.battleAreaID)[1]
    self.battleData = mtBattleBaseInfo().new(battleInfo)
end


--设置我的怪兽
--玩家自身
function BattleMgr:setMyMonster(player)
    self.player = player
end

function BattleMgr:getMyMonster( )
    return self.player
end
--设置当前的 战斗场景(暂时没用到的)
function BattleMgr:setScene(scene)
    self.battleScene = scene
end

-- 获得当前的战斗场景
function BattleMgr:getScene(  )
    return self.battleScene
end

function BattleMgr:getBattleData( )
    return self.battleData
end

function BattleMgr:setBattleStage( stage )
   self.battleStage = stage
end

function BattleMgr:getBattleStage( )
   return self.battleStage
end

function BattleMgr:getBattleStageDesc( )
  local str = ""
   switch(self.battleStage) : caseof
    {
     [BattleStage.init]  = function()  
         str = "游戏准备开始……"
      end,
     [BattleStage.level1] = function()  
         str = "一阶段开始……"
      end,
     [BattleStage.level2]    = function()   
         str = "二阶段开始……"
      end,
     [BattleStage.level3]  = function()  
         str = "三阶段开始……"
     end, 
     [BattleStage.ended]  = function()   
         str = "游戏结束……"
     end,
    }
    return str
end

function BattleMgr:getBattleAreaID( )
   return self.battleAreaID
end

--获取当前存活的怪兽
function BattleMgr:getMonsterList( )
   return self.monsterList
end

--获取 生成过的怪兽（包含当前存活和已经死亡的）
function BattleMgr:getAllMonsterList(  )
   return self.allMonsterList
end

----------------------------------------------------怪兽----------------------------------------

--添加怪兽进入列表
--[[
    会存在 怪兽ID相同的怪兽 所以 不能以 怪兽ID 做index 
    希望 以后可以通过 怪兽生成的时间 做区分
    存进来的是 怪兽的实例
]]
function BattleMgr:addMonsterToList(monster)
	  if monster then 
       table.insert(self.monsterList,monster)
       --将该怪兽的类型记录下来
       local monsterID = monster:getLogic():getMonsterData():getMonsterID()
       if self.allMonsterList[monsterID] == nil then 
          self.allMonsterList[monsterID] = 1
       else
          self.allMonsterList[monsterID] = self.allMonsterList[monsterID] + 1
       end
	  end
end

--[[
    从当前存活的怪兽表中剔除
]]
function BattleMgr:removeMonsterFromList(monster)
  	if monster then 
       for k,v in ipairs(self.monsterList) do
       	   if v and v == monster then 
              table.remove(self.monsterList,k)
              break
       	   end
       end
  	end
end

--[[
    获得各阶级的怪兽数组 通过阶级来区分
    return monstersByLevelList.monsters 各阶级怪兽的数组
           monstersByLevelList.count 各阶级怪兽的数量
]]
function BattleMgr:getMonsterListByLevel( )
    local monstersByLevelList = {}
    local totalMonstersCounts = 0
    for k,v in ipairs(self.monsterList) do
        if v then 
           local level = v:getLogic():getMonsterData():getInitMonsterLevel()
           if monstersByLevelList[level] == nil then 
              monstersByLevelList[level] = {}
              monstersByLevelList[level].count = 0
              monstersByLevelList[level].monsters = {}
           else 
              table.insert(monstersByLevelList[level].monsters,v)
              monstersByLevelList[level].count = monstersByLevelList[level].count + 1
           end
           totalMonstersCounts = totalMonstersCounts + 1
        end
    end

    return monstersByLevelList,totalMonstersCounts
end

--根据怪兽ID 获取 战场曾经生成过多少该种类的怪兽数量
function BattleMgr:getMonsterMaxCountByID( monsterID )
   --为空时，说明还没有生成过
   if self.allMonsterList[monsterID] == nil then 
      return 0
   else 
      return self.allMonsterList[monsterID]
   end
end


--根据 initPos skillRangeType 来获得 在当前在探测范围内的坐标点数组
function BattleMgr:detectMonster(initPos,skillRangeInfo)
    
    --要区分。。怪物自身 不能放进去  2016年4月29日02:30:53 明天再弄吧
    --2016年5月1日15:29:30。。技能范围不包含自身，所以不存在这个问题
    local targetPosList = mtSkillDetect():getSkillDetectPosList(initPos,skillRangeInfo)

    local targetMonsterList = {}

    --递归查找 是否有满足 在范围坐标点数组内的怪兽
    if self.monsterList and #self.monsterList > 0 then 
        for k,v in ipairs(self.monsterList) do
           if v then 
              local monsterPos = v:getTiledMapPos()
              for kk,vv in ipairs(targetPosList) do
                  --当前坐标 和 存活的怪物有相同的 则 存放在 范围内怪兽数组里
                  if vv and vv.x == monsterPos.x and vv.y == monsterPos.y then 
                     table.insert(targetMonsterList,v)
                  end
              end
           end
        end
    end

    return targetMonsterList
end

------------------------------------------------孵化场管理部分-------------------------------------

--添加孵化场进入列表
--[[
     
]]
function BattleMgr:addHatcheryToList(hatchery)
    if hatchery then 
       table.insert(self.hatcheryList,hatchery)
    end
end

--[[
    剔除 孵化场
]]
function BattleMgr:removeHatcheryFromList(hatchery)
    if hatchery then 
         for k,v in ipairs(self.hatcheryList) do
             if v and v == hatchery then 
                table.remove(self.hatcheryList,k)
                break
             end
         end
    end
end

----------------------------------------------------战斗调度器--------------------------------------------

function BattleMgr:startUpdateBattle( )
    --要想开始，先要结束
    self:stopUpdateBattle( )
    --更新战斗信息 每帧调度一次
    self.updateBattleHandler = mtSchedulerMgr():addScheduler(0,-1,handler(self,self.updateBattle))
    --扣除  耐饿值 每秒调度一次
    self.updateMonsterSatiationHandler = mtSchedulerMgr():addScheduler(1,-1,handler(self,self.updateMonsterSatiation))

end

function BattleMgr:stopUpdateBattle( )
    
    self.updateBattleHandler = mtSchedulerMgr():removeScheduler(self.updateBattleHandler)
 
    self.updateMonsterSatiationHandler = mtSchedulerMgr():removeScheduler(self.updateMonsterSatiationHandler)

end

--每帧去判断 当前的游戏状态 
--根据因素 当前玩家 的 进化值 饱食度 等因素 来做阶段区分
--这里应该是地图内的所有玩家 ，取最高值 进行判断

function BattleMgr:updateBattle( )
    --检查战场状态
    self:checkBattleStage()
    --这里去遍历每个怪兽对象的心脏跳动 节省mtSchedulerMgr() 的数组数量
    self:updateAllMonstersHeart()
    --遍历每个孵化场的心脏跳动
    self:updateAllHatcheriesHeart()
end

--检查当前的战斗状态
--这里还需要改一下
function BattleMgr:checkBattleStage(  )
    
    --当前玩家的 饱食度 和 进化值
    local playerSatiation = self.player:getMonsterData():getMonsterNowSatiation()
    local playerEvolution = self.player:getMonsterData():getMonsterNowEvolution()
    --敌方玩家的 饱食度 和 进化值
    --

    if playerSatiation <= 0 then 
       mtEventDispatch():dispatchEvent(BATTLE_STATE_END,{winer = PlayerType.player})
    end

    if self.battleStage == BattleStage.init then 
       mtEventDispatch():dispatchEvent(BATTLE_STAGE_REFRESH) 
    end

    --阶段是不能跳跃的，只能一步一步的来，相同的阶段就不会持续发消息
    --第一阶段
    if playerEvolution < 20 then 
       if self.battleStage == BattleStage.init then 
          self:setBattleStage(BattleStage.level1)
          mtEventDispatch():dispatchEvent(BATTLE_STAGE_REFRESH)
       end
    --第二阶段
    elseif playerEvolution >= 20 and playerEvolution < 80 then 
       if self.battleStage == BattleStage.level1 then
          self:setBattleStage(BattleStage.level2)
          mtEventDispatch():dispatchEvent(BATTLE_STAGE_REFRESH)  
       end
    --第三阶段
    elseif playerEvolution >= 80 and playerEvolution < 100 then 
       if self.battleStage == BattleStage.level2 then
          self:setBattleStage(BattleStage.level3)
          mtEventDispatch():dispatchEvent(BATTLE_STAGE_REFRESH)
       end
    --进化完成 游戏结束
    elseif playerEvolution == 100 then 
       if self.battleStage == BattleStage.level3 then
          self:setBattleStage(BattleStage.ended)
          mtEventDispatch():dispatchEvent(BATTLE_STATE_END) 
       end
    end
end


--每秒扣除  耐饿值
function BattleMgr:updateMonsterSatiation( )
    --每只怪兽都扣除一下
    if self.monsterList and #self.monsterList > 0 then 
        for k,v in ipairs(self.monsterList) do
           if v then 
              v:getLogic():decSatiation()    
           end
        end
    end
    --刷新主界面 玩家信息
    self.battleScene:refreshPlayerInfo()
end

--更新存活怪兽的心脏跳动
function BattleMgr:updateAllMonstersHeart( )
    --刷新玩家自身的
    if self.player then 
       self.player:getLogic():updateMonsterHeart()
    end
    if self.monsterList and #self.monsterList > 0 then 
        for k,v in ipairs(self.monsterList) do
           if v then 
              v:getLogic():updateMonsterHeart()    
           end
        end
    end
end

--更新激活的孵化场的心脏跳动
function BattleMgr:updateAllHatcheriesHeart( )
    if self.hatcheryList and #self.hatcheryList > 0 then 
        for k,v in ipairs(self.hatcheryList) do
           if v then 
              v:getLogic():updateHatcheryHeart()    
           end
        end
    end
end

------------------------------------------------行为日志-----------------------------------------

--获得当前的怪兽日志ID
--只有在怪兽出生的时候调用一次，不允许重复调用
function BattleMgr:getNowMonsterLogID(monsterID)

    self.monsterLogID = self.monsterLogID + 1
    self.monsterLogMonsterID[self.monsterLogID] = monsterID
    
    mtEventDispatch():dispatchEvent(BATTLE_NEW_BEHAVIORLOG_BTN) 

    return self.monsterLogID
end

--获得当前最大的怪物日志ID
function BattleMgr:getMonsterLogID( )
    return self.monsterLogID
end

--获得monsterLogID 指定的怪兽的ID（对应查表去找怪物信息）
function BattleMgr:getMonsterIDByMonsterLogID(monsterLogID)
   return self.monsterLogMonsterID[monsterLogID]
end

--添加怪物行为日志
function BattleMgr:addBehaviorLog(monsterLogID,behaviorType)

    if self.monsterLogList[monsterLogID] == nil then 
       self.monsterLogList[monsterLogID] = {}
    end

    local index = #self.monsterLogList[monsterLogID] + 1
    local data = {}

    data.index = index
    data.monsterLogID = monsterLogID
    data.behaviorType = behaviorType

    local behaviorLog = mtBehaviorLogInfo().new(data)

    table.insert(self.monsterLogList[monsterLogID] ,index , behaviorLog)

    --推送到 行为日志视图中 去添加
    mtEventDispatch():dispatchEvent(BATTLE_NEW_BEHAVIORLOG,{ newLog = behaviorLog})  
     
    --输出怪物在做什么。（临时做法）
    --print(behaviorLog:getLogStr())

end

--获得monsterLogID 怪兽行为日志列表
function BattleMgr:getBehaviorLogByID( monsterLogID )
    if self.monsterLogList[monsterLogID] ~= nil then 
       return self.monsterLogList[monsterLogID]
    end
end


return BattleMgr
