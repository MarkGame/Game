--
-- Author: HLZ
-- Date: 2016-04-24 15:33:31
-- 怪兽的通用逻辑
-- 

local CommonMonsterLogic = class("CommonMonsterLogic")

function CommonMonsterLogic:ctor(data)

   self.parentScene = mtBattleMgr():getScene()
   self.monsterID = data.monsterID
   self.playerType = data.playerType
   
    --获得怪兽行为日志的ID  一只怪兽只能调用一次
   self.monsterLogID = mtBattleMgr():getNowMonsterLogID(self.monsterID)
   
   --怪兽的基本信息
   self.monsterInfo = nil
   --怪兽的吞噬技能
   self.devourSkill = nil 
   --怪兽的探测技能
   self.detectSkill = nil
   --怪兽的专属技能 
   self.exclusiveSkill = nil
   
   --目标怪兽 【可能是单个，也可能是一个数组，我觉得后面统一为数组比较好】
   --记得 结束后清空该目标，方便为下次寻找；
   self.targetMonster = nil

   --初始化 怪兽信息
   self:initMonsterInfo()

   --BUFF列表
   self.buffList = {}

   --流动技能表（敌对怪兽才用的到，普通怪兽只有一个专属技能）
   self.flowSkillsList = {}
   
end

--初始化 怪兽信息
function CommonMonsterLogic:initMonsterInfo( )
	  --获得表格里面的怪兽信息
	  self.monsterInfo = g_Config:getData("Monster","ID",self.monsterID)[1]
    
    self.monsterData = mtMonsterBaseInfo().new(self.monsterInfo)

    --初始化状态机
    self:initStateMachine()

end

--获得怪兽的即时数据
function CommonMonsterLogic:getMonsterData()
	return self.monsterData
end


--设置怪兽出生时间
function CommonMonsterLogic:setMonsterBirthTime(time)
  self.monsterData:setBirthTime(time)
end

--获得 吞噬技能
function CommonMonsterLogic:getDevourSkill( )
  return self.devourSkill
end

--获得 探测技能 
function CommonMonsterLogic:getDetectSkill( )
  return self.detectSkill
end

--获得 专属技能
function CommonMonsterLogic:getExclusiveSkill( )
  return self.exclusiveSkill
end

--获得怪兽信息
function CommonMonsterLogic:getMonsterInfo( )
  return self.monsterInfo
end

--获得怪兽ID
function CommonMonsterLogic:getMonsterID( )
  return self.monsterID
end

--移除怪兽
function CommonMonsterLogic:removeMonster(  )
   --现在这里暂时不做操作
   mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.die,self.playerType)
   if self.monster then 
      self.monster:removeFromParent()
   end
end

--获得怪兽的TiledPos x,y
function CommonMonsterLogic:getMonsterTileCoordPos( )
    local tileCoordPos = self.parentScene:tileCoordForPosition(cc.p(self.monster:getPosition()))
    return tileCoordPos.x ,tileCoordPos.y
end

--获得怪兽的Pos x,y
function CommonMonsterLogic:getMonsterPos( )
    local pos =  cc.p(self.monster:getPosition())
    return pos.x,pos.y
end

function CommonMonsterLogic:setTargetMonster(target)
    self.targetMonster = nil 
    self.targetMonster = target
end

function CommonMonsterLogic:isEnemyPlayer( )
    if self.playerType and self.playerType == PlayerType.enemy then 
       return true
    else
       return false
    end 
end
----------------------------------------------怪兽心跳 START----------------------------------------------

--每帧心跳检测
--[[
    检查身上的BUFF 并执行等
    由BattleMgr() 的 updateAllMonstersHeart()统一调度
]]
function CommonMonsterLogic:updateMonsterHeart( )
    --检查自身的属性值
    self:checkMonsterData()
    --遍历自身BUFF并检查执行
    self:refreshOwnedBuff()
    
end
----------------------------------------------怪兽心跳 END--------------------------------------------------

----------------------------------------------怪兽自身属性检查 START----------------------------------------
function CommonMonsterLogic:checkMonsterData( )
    local nowSatiation = self.monsterData:getMonsterNowSatiation()
    if nowSatiation <= 0 then 
       --删除怪兽
       self.monster:removeMonster()
    end

end
----------------------------------------------怪兽自身属性检查 END------------------------------------------


----------------------------------------------携带BUFF模块 模块 START---------------------------------------

--[[
    先检测 当前BUFF列表里面是否有同类型BUFF，
           如果有，则刷新BUFF的时间（可以叠加的BUFF对应叠加BUFF效果）
           没有则直接加入
]]
function CommonMonsterLogic:addBuffToBuffList(buff)
    local isNewTypeBuff = true
    for k,v in ipairs(self.buffList) do
        --如果当前已经有相同BUFF，BUFF叠加
        if v:getBuffData():getBuffID() == buff:getBuffData():getBuffID() then 
           -- 叠加相关操作
           isNewTypeBuff = false
           break
        end
    end
    
    --是新添加的BUFF类型 加入BUFF列表中去
    if isNewTypeBuff == true then 
       table.insert(self.buffList,buff)
    end

end
--[[
    清空身上所有的BUFF
]]
function CommonMonsterLogic:clearBuffList()
    for k,v in ipairs(self.buffList) do
        if v then 
           v:removeBuff()
           v = nil
           table.remove(self.buffList,k)
        end
    end
    self.buffList = {}
end

--[[
    移除身上指定的BUFF，BUFF自身销毁，从列表中剔除
]]
function CommonMonsterLogic:removeBuffFromBuffList(buff)
    for k,v in ipairs(self.buffList) do
        --如果当前已经有相同BUFF，BUFF叠加
        if v:getBuffData():getBuffID() == buff:getBuffData():getBuffID() then 
           v:removeBuff()
           v = nil
           table.remove(self.buffList,k)
           break
        end
    end
end

--在每一帧里面去刷新自身的BUFF，是否在CD时间内
function CommonMonsterLogic:refreshOwnedBuff()
    for k,v in ipairs(self.buffList) do
        if v then 
          if v:isDurationTime() == true then
             v:launch(self.monster)
          else
             self:removeBuffFromBuffList(v)
          end
        end
    end
end

----------------------------------------------携带BUFF模块 END---------------------------------------

----------------------------------------------技能模块 START-----------------------------------------
--初始化 怪兽技能 一般是三个
function CommonMonsterLogic:initMonsterSkill( )

    --创建 吞噬技能
    self.devourSkill = mtSkillMgr():createSkill(self.monsterInfo.DevourSkillID)
    --创建 探测技能  
    self.detectSkill = mtSkillMgr():createSkill(self.monsterInfo.DetectSkillID)
    --创建 专属技能
    self.exclusiveSkill = mtSkillMgr():createSkill(self.monsterInfo.ExclusiveSkillID)

end

--敌对主怪才用的到的流动技能
--创建一个流动技能，需要填入技能ID
function CommonMonsterLogic:createFlowSkill( skillID )
    local newFlowSkill = mtSkillMgr():createSkill(skillID)
    if newFlowSkill then 
         self:addSkillToFlowSkillsList(newFlowSkill)
    end
end

--添加技能到 流动技能数组
function CommonMonsterLogic:addSkillToFlowSkillsList(skill)
    --判断 当前流动技能数组 是否已满
  
    if #self.flowSkillsList < 3 then --当流动技能数组小于三个技能时，可以直接添加 
         table.insert(self.flowSkillsList,skill)
    else --当流动技能数组大于等于三个时，按一定规则删除技能
         self:deleSkillFromFlowSkillsList(1) 
    end

end

--第index号技能从 流动技能数组 删除
function CommonMonsterLogic:deleSkillFromFlowSkillsList(index)
    --技能满的时候，将第一个技能移除，其他技能依次向前移位
    local discardSkill = self.flowSkillsList[index]
    --discardSkill:removeSkill()
    table.remove(self.flowSkillsList,index)
      
    if self.flowSkillsList and #self.flowSkillsList > 1 then 
       for k,v in ipairs(self.flowSkillsList) do
           --把flowSkillsList剩余的技能 依次向前移动
           if self.flowSkillsList[1] == nil and k > 1 then 
                local tempSkill = v
                table.insert(self.flowSkillsList,1,skill)
           elseif self.flowSkillsList[2] == nil and k > 2 then 
                local tempSkill = v
                table.insert(self.flowSkillsList,2,skill)
           elseif self.flowSkillsList[3] == nil then 
                local tempSkill = v
                table.insert(self.flowSkillsList,3,skill)
           end
       end
    end
end

--获得制定的 流动技能
function CommonMonsterLogic:getFlowSkillByIndex(index)
    if self.flowSkillsList and self.flowSkillsList[index] ~= nil then 
         return self.flowSkillsList[index]
      else
         return nil
    end 
end

----------------------------------------------技能模块 END--------------------------------------------

----------------------------------------------怪兽大脑 模块 START---------------------------------------
--[[
    影响大脑做出决策的几种因素：
        1、传承记忆   【在同一场战斗中，后面生成的怪兽会继承之前死掉怪物的记忆，做到数据共享】
        2、个性       【个性主宰该怪物的行为，比如勇猛的怪物会一直去吞噬，并主动控制玩家怪兽，胆小的则会一直逃跑】
        3、模糊数据   【从探测获得的模糊数据进行分析，是否要进攻等】
        4、自身状态   【根据自身的状态进行分析，是需要进食，还是逃跑，还是待机】
    这边先是简单处理：
        通关个性来主宰一切
    

]]

--初始化 怪兽大脑
function CommonMonsterLogic:initMonsterBrain( monster )
   
   --初始化 基础框架
   --加入个性信息
   --检查是否有记忆传承
   --第一步是搜寻目标？？还是做个随机决策
   --反向获得 怪兽本身的实例
   self.monster = monster
   --初始技能
   self:initMonsterSkill()
   
   --启动大脑
   self:runningBrain()
   
end

--[[
    使用怪兽大脑 来做出决策
    
    决策举例：
             捕食： 发现目标是可以吞噬的，追捕并吞噬，追捕期间可以释放技能来增加成功率
             逃跑： 发现探测范围有强大的怪兽，在安全坐标点内随机一个，进行移动
             待机： 四处找些坐标 到处走走 暗中观察

    获得反馈的类型和结果，从而去指定下一步的操作
    要规范化一下

    这里的target 可能是单个目标，也可能是一堆目标

    这里应该要废弃，使用 状态机来做这些事情
]]

function CommonMonsterLogic:runningBrain()
    --执行第一步操作
   self:doEvent("toSearch")
end

----------------------------------------------怪兽大脑 模块 END---------------------------------------------

-----------------------------------------------休息 模块 START----------------------------------------------
--冷静一下
function CommonMonsterLogic:calm(  )
   print("enter calm ")
   local func = function ( )
       print("enter toSearch ")
       self:doEvent("toSearch")
       self.updateDelayHandler = mtSchedulerMgr():removeScheduler(self.updateDelayHandler)
   end

   self.updateDelayHandler = mtSchedulerMgr():removeScheduler(self.updateDelayHandler)

   self.updateDelayHandler = mtSchedulerMgr():addScheduler(1,-1,func)

end

-----------------------------------------------休息 模块 END------------------------------------------------


----------------------------------------------智能搜寻目标 模块 START---------------------------------------
--[[
    先使用 探测技能 把所有在视野内的目标 找到，逐一分析
]]
function CommonMonsterLogic:autoSearchTarget( )
    
    --self.detectSkill:showSkillRangeDiagram(self.monster)
    local targets = self.detectSkill:getDetectMonsterBySkill(self.monster)
    -- dump(targets)
    if targets and #targets > 0 then --找到目标后，告诉大脑 下一步要做什么
       self:setTargetMonster(targets)
       -- dump(self.targetMonster)
       self:doEvent("toSelect")
    else           --没有找到目标，也要回调给大脑信息
       self:doEvent("toAutoMove")
    end

end


--[[
智能选择一下 目标，并作出下一步的指令
]]
function CommonMonsterLogic:autoSelectTarget()

    if self.targetMonster and #self.targetMonster > 0 then 
       --这里先优先选择 最近的 一个目标
       local target = self.targetMonster[1]
       self:setTargetMonster(target)
       self:doEvent("toChase")
    else
       self:doEvent("toAutoMove")
    end

end

--[[
    当找不到目标时，执行随机移动 到达随机坐标后，回调给智能搜寻目标，继续做决策
    随机五次坐标，如果都不满足，则保持原地不动
    判断随机坐标的可行性
]]
--自动随机移动 
function CommonMonsterLogic:autoRandomMovement( )
 
    local initX,initY = self:getMonsterTileCoordPos()
  
    --最多执行五次，否则保持执行搜寻目标
    for i = 1 , 5 do 
        local randomX = math.random(-3,3)
        randomX = math.random(-3,3)
        randomX = math.random(-3,3)
        randomX = math.random(-3,3)
        randomX = math.random(-3,3)

        local randomY = math.random(-3,3)
        randomY = math.random(-3,3)
        randomY = math.random(-3,3)
        randomY = math.random(-3,3)
        randomY = math.random(-3,3)

        local target = cc.p(randomX+initX,randomY+initY)
        --判断新的坐标是否是可行点，不行则继续searchPos
        if self.parentScene:targetPosIsBarrier(target) == true then 
           local func = function ( )
              self:doEvent("toSearch")
           end
           self.monster:moveToward(target,func)
           break
        else
           if i == 5 then 
              self:doEvent("toIdle")
           end
        end
    end

end

----------------------------------------------智能搜寻目标 模块 END-----------------------------------------


----------------------------------------------吞噬 模块 START-----------------------------------------------

--吞噬目标怪兽 这里怪兽只有一只
--根据公式 来计算吞噬的几率
--成功 则执行 目标怪兽的销毁 和 增加对应的饱食度 和 进化值 
--失败 则执行 禁锢BUFF 并给目标怪兽 增加不可吞噬的BUFF
function CommonMonsterLogic:devourMonster( )
   local callBack = function (  )
       self:doEvent("toIdle")
   end
   self.devourSkill:devourMonster(self.monster,callBack)
end

--增加饱食度
function CommonMonsterLogic:addSatiation( value )
  local nowSatiation = self.monsterData:getMonsterNowSatiation()
  local maxSatiation = self.monsterData:getMonsterMaxSatiation()
  if nowSatiation + value < maxSatiation then 
     nowSatiation = nowSatiation + value
  else
       nowSatiation = maxSatiation
       --怪兽完成进化
       --执行 巴拉巴拉 等
  end
  --刷新怪兽的饱食度
  self.monsterData:setMonsterNowSatiation(nowSatiation)
end

--减少饱食度
function CommonMonsterLogic:decSatiation( value )
  local nowSatiation = self.monsterData:getMonsterNowSatiation()
  --如果传入的value为空值 则属于自然扣除饱食度
  if value == nil then 
     value = self.monsterData:getMonsterHungry()
  end
  
  if nowSatiation - value > 0 then 
     nowSatiation = nowSatiation - value
  else 
       nowSatiation = 0
       --饱食度为0 怪兽死亡
       --在checkMonsterData统一去判断
  end
  --刷新怪兽的饱食度
  self.monsterData:setMonsterNowSatiation(nowSatiation)
end

--增加进化值
function CommonMonsterLogic:addEvolution( value )
  local nowEvolution = self.monsterData:getMonsterNowEvolution()
  local maxEvolution = self.monsterData:getMonsterMaxEvolution()
  if nowEvolution + value < maxEvolution then 
     nowEvolution = nowEvolution + value
  else
       nowEvolution = maxEvolution
       --完成进化
       --
  end
  self.monsterData:setMonsterNowEvolution(nowEvolution)
end

----------------------------------------------吞噬 模块 END------------------------------------------------

----------------------------------------------使用专属技能 模块 START -------------------------------------
 
function CommonMonsterLogic:useExclusiveSkill()
    self.exclusiveSkill:launch(self.monster)
end

----------------------------------------------使用专属技能 模块 END -------------------------------------


----------------------------------------------怪兽追逐目标 模块 START---------------------------------------
--[[
    逻辑思路：
    根据传进来的target 开始该目标的及时坐标，每移动一格进行一次判断
    if target ~= nil then 
       当前目标没有被销毁（自然饿死，被吞噬等因素从地图中移除）
       则获取当前的目标的新坐标，如果新坐标没有变化，则继续执行上一个寻路，
                                 否则，清除上一个寻路，开始一个新的寻路
       if 该目标已经在技能范围内then 
          则终止寻路，并使用技能 ，告诉大脑，开始新的一轮行为，该行为终止 
       else 不在技能范围内
          则继续寻路
       end
    else
       目标被销毁，告诉大脑，开始新的一轮行为，该行为终止
    end

    加入 限制条件 用来强制结束追捕过程
    条件未定，有以下预备役条件
    判断条件1： 
             总共移动距离
    判断条件2：
             追捕时长
    判断条件3:
             领地规则


    target 目标

    使用专属技能 self.exclusiveSkill  寻找到目标以后使用的技能
     
    2016年10月20日11:21:46 
    导致现在游戏中断的主要凶手，具体问题还没有找到，需要多打日志来观察

]]

function CommonMonsterLogic:chaseToTarget(_target)
    local target = _target
    if target == nil then 
       target = self.targetMonster
    end

    local function funcFinish( )
        print("funcFinish ")
        self.monster:stopMoveToward()
        self:doEvent("toIdle")
        return
    end

    --如果此时丢失了目标，则进入等待 并结束当前动作
    if target == nil then 
       print("target == nil funcFinish ")
       funcFinish()
    end
    
    --获得目标的当前坐标
    local targetPos = self.parentScene:tileCoordForPosition(cc.p(target:getPosition()))
    --show 探索范围
    self.detectSkill:showSkillRangeDiagram(self.monster)

    local function funcStep( )
       if target ~= nil then --目标没有被销毁
          print("target ~= nil")
          local isFindBySkill = self.exclusiveSkill:isTargetInDetectList(self.monster,target)
          local isFindByDevourSkill = self.devourSkill:isTargetInDetectList(self.monster,target)
          --成功靠近了目标，并回调值为true
          if isFindByDevourSkill == true then 
             --吞噬技能范围内，可以吞噬，发出吞噬指令
             print( " isFindByDevourSkill == true  toDevour")
             self.detectSkill:hideSkillRangeDiagram()
             self:doEvent("toDevour")
             self.monster:stopMoveToward()
          else
              --在可以释放skill技能范围内时，回调，并继续执行追捕过程
              if isFindBySkill == true then   
                 --skill释放指令 释放不释放不影响
                 print( " isFindBySkill == true  toUseExclusive")
                 self.detectSkill:hideSkillRangeDiagram()
                 self:doEvent("toUseExclusive")
              end

              local nowTargetPos = self.parentScene:tileCoordForPosition(cc.p(target:getPosition()))
              if targetPos.x == nowTargetPos.x and targetPos.y == nowTargetPos.y then  --如果目标没有发生移动,不执行
                 --print("不执行") 
                 --2016年10月20日10:48:01 这里存在问题 逻辑再好好整理一下
                 print( " nowTargetPos == targetPos  to do nothing")
                 return false
              else  --目标发生移动 开始新的寻路
                 --print("开始新的寻路")
                 print( " to a new move ")
                 targetPos = nowTargetPos
                 self.monster:stopMoveToward()
                 self.monster:moveToward(targetPos,funcFinish,funcStep)
              end
          end
      else
          print("target ~= nil toIdle") 
          self.detectSkill:hideSkillRangeDiagram()
          self.monster:stopMoveToward()
          self:doEvent("toIdle")     
      end
    end
    --向目标距离 移动，移动结束回调，分步回调
    self.monster:moveToward(targetPos,funcFinish,funcStep)

end

----------------------------------------------怪兽追逐目标 模块 END---------------------------------------

----------------------------------------------怪兽逃跑目标 模块 START---------------------------------------
--[[
    逃跑的规则：
    获取需要远离的对象的坐标，然后算出安全的坐标，并向安全的坐标移动
    为了防止 不会太变态，所以，逃跑方除了 特定速度很快，逃跑技能很强的怪兽，属于弱势方
]]

function CommonMonsterLogic:escapeFromTarget()
   
end


----------------------------------------------怪兽逃跑目标 模块 END---------------------------------------

----------------------------------------------怪兽FSM状态机 模块 START---------------------------------------

--初始化 动作状态机
--这里需要好好划分一下
--[[
    
  onleave red - 离开红色状态时的回调
  onleave state - 离开任何状态时的回调
  onenter green - 进入绿色状态时的回调
  onenter state - 进入任何状态时的回调

  onbefore clear - clear事件执行前的回调
  onbefore event - 任何事件执行前的回调
  onafter clear - clear事件完成之后的回调
  onafter event - 任何事件完成之后的回调

  执行顺序
  onbeforeisJump  1
  onenterjump     2
  onafterisJump   3
  onleavejump     4


  self.fsm:isReady()-返回状态机是否就绪
  self.fsm:getState()-返回当前状态
  self.fsm:isState(state)-判断当前状态是否是参数state状态
  self.fsm:canDoEvent(eventName)-当前状态如果能完成eventName对应的event的状态转换，则返回true
  self.fsm:cannotDoEvent(eventName)-当前状态如果不能完成eventName对应的event的状态转换，则返回true
  self.fsm:isFinishedState()-当前状态如果是最终状态，则返回true
  self.fsm:doEventForce(name, ...)-强制对当前状态进行转换
    
  逻辑的状态机  是怪物大脑的 指令执行器
    
  状态 (暂定)
  state:
      应该根据配表 来读取 不能在程序里面写死
      这里只是行动上面的状态


  事件
  event:



  逻辑整理：


]]
function CommonMonsterLogic:initStateMachine( )

  print(" initStateMachine ")
  self.fsm = mtStateMachine().new()

  self.fsm:setupState({
    --初始状态
    --希望这里能够读表
    --正在配置表，等待test
    initial = "idle",
    events = {
              {name = "toIdle", from = {"search","autoMove","chase","escape","devour","useExclusive","selectTarget"}, to = "idle"},    --执行搜寻
              {name = "toSearch", from = {"idle","autoMove","chase","escape","devour","useExclusive","selectTarget"}, to = "search"},    --执行搜寻
              {name = "toSelect", from = {"idle","autoMove","chase","escape","devour","useExclusive","search"}, to = "selectTarget"},    --去选择目标
              {name = "toAutoMove", from = {"idle","search","chase","escape","devour","useExclusive","selectTarget"}, to = "autoMove"},  --随机移动
              {name = "toChase", from = {"idle","search","autoMove","escape","devour","useExclusive","selectTarget"}, to = "chase"},     --追捕
              {name = "toEscape", from = {"idle","search","chase","devour","useExclusive","selectTarget","autoMove"}, to = "escape"},           --逃跑
              {name = "toDevour", from = {"idle","search","chase","escape","useExclusive","selectTarget","autoMove"}, to = "devour"},    --吞噬
              {name = "toUseExclusive", from = {"idle","search","chase","escape","devour","selectTarget","autoMove"}, to = "useExclusive"},  --使用专属技能
          },
        callbacks = {
           
           -- toIdle
           onbeforidle = function(event) end, 
           onenteridle = function(event)
              mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.idle,self.playerType)
              self:calm() 
           end,
           onafteridle  = function(event)  end,
           onleaveidle = function(event)  end,
          
           -- toSearch
           onbeforesearch = function(event) end, 
           onentersearch = function(event) 
              mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.search,self.playerType)
              self:autoSearchTarget() 
           end,
           onaftersearch  = function(event)  end,
           onleavesearch = function(event)  end,

           -- toSelect
           onbeforeselectTarget = function(event) end, 
           onenterselectTarget = function(event) 
              mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.selectTarget,self.playerType)
              self:autoSelectTarget() 
           end,
           onafterselectTarget  = function(event)  end,
           onleaveselectTarget = function(event)  end,
                     
           -- toAutoMove
           onbeforeautoMove = function(event) end, 
           onenterautoMove = function(event) 
              mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.autoMove,self.playerType) 
              self:autoRandomMovement() 
           end,
           onafterautoMove = function(event)  end,
           onleaveautoMove = function(event)  end,

           -- toChase
           onbeforechase = function(event) end, 
           onenterchase = function(event) 
              mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.chase,self.playerType)
              self:chaseToTarget() 
           end,
           onafterchase  = function(event)  end,
           onleavechase = function(event)  end,

           -- toEscape
           onbeforeescape = function(event) end, 
           onenterescape = function(event) 
              mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.escape,self.playerType)
              self:escapeFromTarget() 
           end,
           onafterescape  = function(event)  end,
           onleaveescape = function(event)  end,

           -- toDevour
           onbeforedevour = function(event) end, 
           onenterdevour = function(event) 
              mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.devour,self.playerType)
              self:devourMonster() 
           end,
           onafterdevour  = function(event)  end,
           onleavedevour = function(event)  end,

           -- toUseExclusive
           onbeforeuseExclusive = function(event) end, 
           onenteruseExclusive = function(event) 
              mtBattleMgr():addBehaviorLog(self.monsterLogID,MonsterBehaviorType.useExclusive,self.playerType)
              self:useExclusiveSkill() 
           end,
           onafteruseExclusive  = function(event)  end,
           onleaveuseExclusive = function(event)  end,

          },
  })
end

--转换状态
function CommonMonsterLogic:doEvent(event,...)
  --dump(self:canDoEvent(event))
  if self:canDoEvent(event) == true then
       self.fsm:doEvent(event,...)
    end
end

--强制转换
function CommonMonsterLogic:doEventForce(event,...)
  self.fsm:doEventForce(event,...)
end

--当前状态如果能完成eventName对应的event的状态转换，则返回true
function CommonMonsterLogic:canDoEvent(event,...)
  return self.fsm:canDoEvent(event,...)
end

--当前状态如果不能完成eventName对应的event的状态转换，则返回true
function CommonMonsterLogic:cannotDoEvent(event,...)
  return self.fsm:cannotDoEvent(event,...)
end

function CommonMonsterLogic:getState()
  return self.fsm:getState()
end
----------------------------------------------怪兽FSM状态机 模块 END---------------------------------------


return CommonMonsterLogic