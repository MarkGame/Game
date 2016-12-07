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
 
  	self.battleStage = BattleStage.init
    self.startTime = mtTimeMgr():getCurTime()
    
    self.battleScene = data.scene
    --当前战场ID
    self.battleAreaID = 101 --data.battleAreaID
    --记录怪兽行为日志的ID
    self.monsterLogID = 0
    --准备倒计时
    self.readyTimeMaxCount = 5

    self.readyTimeCount = self.readyTimeMaxCount
    
    --怪兽行为日志的怪兽ID
    self.monsterLogMonsterID = {}
    --怪兽行为日志数组
    self.monsterLogList = {}
    --当前存活的怪兽表
    --仅包含 中立怪 
    self.monsterList = {}
    --孵化出的怪兽（保护已经死亡，消失的）
    --根据怪兽的ID 来存放
    self.allMonsterList = {}
    --当前激活的孵化场
    self.hatcheryList = {}

    --当前的敌对玩家数组 
    self.enemyPlayerList = {}

    self:initBattleInfo()

    self:enterReadyTime()

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

--设置敌人的怪兽
--敌人自身
function BattleMgr:setEnemyMonster(enemy)
    self.enemy = enemy
end

function BattleMgr:getEnemyMonster( )
    return self.enemy
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
     [BattleStage.readyTime]  = function()  
         str = "游戏准备阶段……"
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

function BattleMgr:endScene( )
   
   --结束更新battle
   self:stopUpdateBattle()

   --等待下一次 进入场景 重新初始化数据

end


------------------------------------------------玩家的创建---------------------------------------

--[[
    initPos 初始坐标 cc.p(x,y)
]]
function BattleMgr:createPlayer(initPos)

    local data = {}
    data.playerType = PlayerType.player
    local player =  mtPlayerMgr():createPlayerView(data)
    self.battleScene:getMap():addChild(player,ZVALUE_BATTLEMAP_PLAYER) 
    --主角初始位置
    local initPlayerPos = self.battleScene:positionForTileCoord(initPos)
    player:setPosition(initPlayerPos)
  
    self:setMyMonster(player)
    self.player = player

    return player

end

--[[
    initPos 初始坐标 cc.p(x,y)
    monsterID 敌对怪兽的ID
]]
function BattleMgr:createEnemy(monsterID,initPos)

    local data = {}
    data.playerType = PlayerType.enemy
    data.monsterID = monsterID
    local enemy =  mtMonsterMgr():createMonster(data)
    self.battleScene:getMap():addChild(enemy,ZVALUE_BATTLEMAP_MONSTER) 
    --主角初始位置
    local initEnemyPos = self.battleScene:positionForTileCoord(initPos)
    enemy:setPosition(initEnemyPos)

    self:addEnemyToList(enemy)

    -- 当前按 1V1 一个怪兽来处理 后面再做数组处理
    self:setEnemyMonster(enemy)
    self.enemy = enemy

    return enemy

end

--添加敌人到敌人数组内
function BattleMgr:addEnemyToList(enemy) 
    if enemy then 
       table.insert(self.enemyPlayerList,enemy)
    end
end

function BattleMgr:getEnemyFromList( )
    
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

----------------------------------------------------准备阶段---------------------------------------------
--[[
    准备阶段 有两种类型 ，一种是手动点击 准备按钮，开始游戏 
                          另一种是 倒计时，时间到则开始游戏
]]
function BattleMgr:enterReadyTime( )
    
    self.readyTimeHandler = mtSchedulerMgr():removeScheduler(self.readyTimeHandler)
    --初始化倒计时时间
    self.readyTimeCount = self.readyTimeMaxCount

    self:setBattleStage(BattleStage.readyTime)
    mtEventDispatch():dispatchEvent(BATTLE_STAGE_REFRESH)
    --开始倒计时
    self.readyTimeHandler = mtSchedulerMgr():addScheduler(1,-1,handler(self,self.updateReadyTime))
   
end

--每秒更新一次 判断是否倒计时结束
function BattleMgr:updateReadyTime( )
    if self.readyTimeCount - 1 < 0 then 
       self.readyTimeHandler = mtSchedulerMgr():removeScheduler(self.readyTimeHandler)
       self.readyTimeCount = self.readyTimeMaxCount
       self:startBattle()
    else
       --显示倒计时
       local str = self.readyTimeCount
       mtFloatMsgMgr():showTips(str,0.2)
       self.readyTimeCount = self.readyTimeCount - 1
    end
end

-- 开始战斗
function BattleMgr:startBattle( )
    --推送消息 开始游戏
    mtEventDispatch():dispatchEvent(BATTLE_READYTIME_END)
    
    --self:startUpdateBattle()
end



----------------------------------------------------战斗调度器--------------------------------------------

function BattleMgr:startUpdateBattle( )
    --要想开始，先要结束上一次
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

--获得当前最新的参考值（最小的饥饿值，以及最大的进化值）
--目前最小的饥饿值还没有具体的作用，后续补充
function BattleMgr:getNowReferenceValue( )
       --当前玩家的 饱食度 和 进化值
    local playerSatiation = self.player:getLogic():getMonsterData():getMonsterNowSatiation()
    local playerEvolution = self.player:getLogic():getMonsterData():getMonsterNowEvolution()

    --敌方玩家的 饱食度 和 进化值
    local enemySatiation = self.enemy:getLogic():getMonsterData():getMonsterNowSatiation()
    local enemyEvolution = self.enemy:getLogic():getMonsterData():getMonsterNowEvolution()

    --得到最低当前最低的饱食度 和 最大的进化值  并需要知道是哪个玩家
    local minSat,minSatPlayerType,maxEvo,maxEvoPlayerType  = nil 
    --这里还要考虑一下 玩家和敌人同时死亡 或者 进化的条件 最好能够避免这种情况的出现
    if playerSatiation < enemySatiation then 
       minSat = playerSatiation
       minSatPlayerType = PlayerType.player
    else
       minSat = enemySatiation
       minSatPlayerType = PlayerType.enemy
    end
    
    if playerEvolution < enemyEvolution then 
       maxEvo = enemyEvolution
       maxEvoPlayerType = PlayerType.enemy
    else
       maxEvo = playerEvolution
       maxEvoPlayerType = PlayerType.player
    end

    return minSat,minSatPlayerType,maxEvo,maxEvoPlayerType
end


--检查当前的战斗状态
--这里还需要改一下
function BattleMgr:checkBattleStage(  )
    
    local minSat,minSatPlayerType,maxEvo,maxEvoPlayerType = self:getNowReferenceValue()
    

    if minSat <= 0 then 
       print("minSat 这里开始游戏结束")
       print(" minSatPlayerType  :  "..minSatPlayerType)
       self:setBattleStage(BattleStage.ended)
       -- mtEventDispatch():dispatchEvent(BATTLE_STATE_END) 
       mtEventDispatch():dispatchEvent(BATTLE_STATE_END,{winer = minSatPlayerType})
    end
    --阶段是不能跳跃的，只能一步一步的来，相同的阶段就不会持续发消息
    --第一阶段
    if maxEvo < 20 then 
       if self.battleStage == BattleStage.readyTime then 
          self:setBattleStage(BattleStage.level1)
          mtEventDispatch():dispatchEvent(BATTLE_STAGE_REFRESH)
       end
    --第二阶段
    elseif maxEvo >= 20 and maxEvo < 80 then 
       if self.battleStage == BattleStage.level1 then
          self:setBattleStage(BattleStage.level2)
          mtEventDispatch():dispatchEvent(BATTLE_STAGE_REFRESH)  
       end
    --第三阶段
    elseif maxEvo >= 80 and maxEvo < 100 then 
       if self.battleStage == BattleStage.level2 then
          self:setBattleStage(BattleStage.level3)
          mtEventDispatch():dispatchEvent(BATTLE_STAGE_REFRESH)
       end
    --进化完成 游戏结束
    elseif maxEvo == 100 then 
       if self.battleStage == BattleStage.level3 then
          print("maxEvo 进化完成 这里开始游戏结束")
          self:setBattleStage(BattleStage.ended)
          -- mtEventDispatch():dispatchEvent(BATTLE_STATE_END) 
          mtEventDispatch():dispatchEvent(BATTLE_STATE_END,{winer = maxEvoPlayerType})
       end
    end
end


--每秒扣除  耐饿值
function BattleMgr:updateMonsterSatiation( )
    
    --刷新主界面 玩家信息
    self.battleScene:refreshPlayerInfo()
    
    --每只怪兽都扣除一下
    if self.monsterList and #self.monsterList > 0 then 
        for k,v in ipairs(self.monsterList) do
           if v then 
              v:getLogic():decSatiation()    
           end
        end
    end

    --刷新玩家自身的
    --test 主角暂时不处理
    if self.player then 
       self.player:getLogic():decSatiation()
    end

    --敌对玩家都扣除一下
    if self.enemyPlayerList and #self.enemyPlayerList > 0 then 
        for k,v in ipairs(self.enemyPlayerList) do
           if v then 
              v:getLogic():decSatiation()    
           end
        end
    end

end

--更新存活怪兽的心脏跳动
function BattleMgr:updateAllMonstersHeart( )
    --刷新玩家自身的
    if self.player then 
       self.player:getLogic():updateMonsterHeart()
    end
    
    --刷新敌对玩家的
    if self.enemyPlayerList and #self.enemyPlayerList > 0 then 
        for k,v in ipairs(self.enemyPlayerList) do
           if v then 
              v:getLogic():updateMonsterHeart()    
           end
        end
    end

    --刷新中立怪兽的
    if self.monsterList and #self.monsterList > 0 then 
        for k,v in ipairs(self.monsterList) do
           if v then 
              v:getLogic():updateMonsterHeart()    
           end
        end
    end
end

--停止所有怪兽的心跳
function BattleMgr:stopAllMonstersHeart( )
    
    --停止玩家自身的
    -- 一般是 夺取玩家的控制权，但有一种情况需要处理，如果玩家怪兽当前正在进行还没有执行完的操作时


    --停止敌对玩家的
    if self.enemyPlayerList and #self.enemyPlayerList > 0 then 
        for k,v in ipairs(self.enemyPlayerList) do
           if v then 
              v:getLogic():doEventForce("toStop")    
           end
        end
    end

    --停止中立怪兽的
    if self.monsterList and #self.monsterList > 0 then 
        for k,v in ipairs(self.monsterList) do
           if v then 
              v:getLogic():doEventForce("toStop")  
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

--停止所有孵化场的心脏跳动
function BattleMgr:stopAllHatcheriesHeart( )
    if self.hatcheryList and #self.hatcheryList > 0 then 
        for k,v in ipairs(self.hatcheryList) do
           if v then 
              v:getLogic():stopNowHatching()    
           end
        end
    end
end

--停止所有怪兽的行为
function BattleMgr:stopAllMonstersAction(  )
    --终止总战斗调度器
    self:stopUpdateBattle()
    --终止全部孵化场心跳
    self:stopAllHatcheriesHeart()
    --终止所有怪兽心跳
    self:stopAllMonstersHeart()
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
function BattleMgr:addBehaviorLog(monsterLogID,behaviorType,monsterType,nowSatiation,nowEvolution)

    if self.monsterLogList[monsterLogID] == nil then 
       self.monsterLogList[monsterLogID] = {}
    end

    local index = #self.monsterLogList[monsterLogID] + 1
    local data = {}

    data.index = index
    data.monsterLogID = monsterLogID
    data.behaviorType = behaviorType
    data.monsterType = monsterType
    data.nowSatiation = nowSatiation
    data.nowEvolution = nowEvolution
    local behaviorLog = mtBehaviorLogInfo().new(data)

    table.insert(self.monsterLogList[monsterLogID] ,index , behaviorLog)

    --推送到 行为日志视图中 去添加
    --mtEventDispatch():dispatchEvent(BATTLE_NEW_BEHAVIORLOG,{ newLog = behaviorLog})  
    
    --输出怪物在做什么。（临时做法）
    print(behaviorLog:getLogStr())

end

--获得monsterLogID 怪兽行为日志列表
function BattleMgr:getBehaviorLogByID( monsterLogID )
    if self.monsterLogList[monsterLogID] ~= nil then 
       return self.monsterLogList[monsterLogID]
    end
end


return BattleMgr
