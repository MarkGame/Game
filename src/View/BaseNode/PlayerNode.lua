--
-- Author: HLZ
-- Date: 2016-01-08 10:51:13
-- 主角节点封装
require("Utils.StateMachine")


PlayerNode = class("PlayerNode",function ()
	return cc.Node:create()
end)

PlayerNode.__index = PlayerNode

--[[
    继承于 PlayerNode的类，需要在ctor() onEnter() onExit() 加上 .super.ctor(self)类似的方法 
    在该类中 封装 相机系统
    enum class CameraFlag
	{
	    DEFAULT = 1,
	    USER1 = 1 << 1,
	    USER2 = 1 << 2,
	    USER3 = 1 << 3,
	    USER4 = 1 << 4,
	    USER5 = 1 << 5,
	    USER6 = 1 << 6,
	    USER7 = 1 << 7,
	    USER8 = 1 << 8,
	    
	};
--]]

function PlayerNode:ctor()
    --进入时，调用onEnter() 
    --退出时，调用onExit()
	self:registerScriptHandler(function ( event )
		if event == "enter" then
			self:onEnter()
		elseif event == "exit" then
			self:onExit()
		end
	end)

    --当前场景监听的事件数组
	self.eventListeners = {}

  self.isPause = false
  
  --初始精灵节点
  self.sprite = nil 
	--相机
	self.camera = nil 

  --初始化 动作状态 
  self.nowState = MoveDirectionType.idle

  self.isMoving = false

  --技能释放指示器
  self.diagram = nil
    
  self:setCameraMask(2)

	self:setName(self.__cname)

	-- local body = cc.PhysicsBody:createBox(self:getContentSize(), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
 --    self:setPhysicsBody(body)

end

function PlayerNode:dispatchEvent(event,data)
	g_EventDispatch:dispatchEvent(event,data)
end


function PlayerNode:registerEvent( event,callBack,groupID,priority )
	--将事件加入数组，方便在退出的时候将侦听事件给移除掉
	self.eventListeners = self.eventListeners or {}
	self.eventListeners[#self.eventListeners + 1] = g_EventDispatch:registerEvent(event,callBack,groupID,priority)
	return self.eventListeners[#self.eventListeners + 1]
end

function PlayerNode:onExit( )
	if self.eventListeners == nil then
		return 
	end
	--统一对事件数组里面的时间进行释放
	for i,v in ipairs(self.eventListeners) do
		g_EventDispatch:removeEvent(v)
	end	
end

function PlayerNode:onEnter( )
	
end

function PlayerNode:onHide(  )
	
end


function PlayerNode:setParentScene(parent)
	 self.parentScene = parent
end

--设置 技能的释放范围
function PlayerNode:setSkillRangeDiagram(diagram)
    self.diagram = diagram
    -- self.diagram:setAnchorPoint(cc.p(0.4,1))
    -- --local size = self:getContentSize()
    -- self.diagram:setPosition(cc.p(0,-50))
    self:addChild(diagram,10)
end

--[[
    现在重构 角色移动 的方法：
    受用对象： 玩家本身控制的主兽
               其他中立怪 使用 自动寻路 给予坐标让其移动。敌方主怪 要么是服务器来模拟 移动，要么是使用自动寻路，这个待定
    基本原理-
        按下移动键位时（触发移动）
        设置状态 向某方向 移动中 
        当 该状态激活时 执行向该方向移动一格的指令（MoveTo)
        当执行结束时，回调判断方法，判断该状态是否激活，还在激活时继续执行，否则就停止
    需要处理的事件-
        1、当按下左键 并在移动过程中 按下右键 当前移动的那个结束之后，立刻向右执行，移动期间不强制移动（待定）
        所以回调的方法 应该 单独写一个去弄
        2、当按下左键，再按下右键，这时候松开左键的时候，需要进行判断； 只有松开左键时，当前的状态是向左的话 才将状态置为 停止
                                                                                        否则，则不改变当前状态


]]

--一般是 首次（按下方向键的时候）使用
--改变 当前状态 
--设置对应的动作动画
function PlayerNode:refreshState(direction)

  self.nowState = direction 

  switch(direction) : caseof
  {
   [MoveDirectionType.left]  = function()   -- 向左移动
        self:moveToLeft() 
        self:playAnim(AnimationType.walkL)
    end,
   [MoveDirectionType.right] = function()   -- 向右移动
        self:moveToRight()
        self:playAnim(AnimationType.walkR)
    end,
   [MoveDirectionType.up]    = function()   -- 向上移动
        self:moveToUp()
        self:playAnim(AnimationType.walkU)
    end,
   [MoveDirectionType.down]  = function()   -- 向下移动
        self:moveToDown()
        self:playAnim(AnimationType.walkD)
   end, 
    }
end

--用于重复调用的时候使用
--只循环执行移动方法
function PlayerNode:_refreshState()
  
  switch(self.nowState) : caseof
  {
   [MoveDirectionType.left]  = function()   -- 向左移动
        self:moveToLeft() 
    end,
   [MoveDirectionType.right] = function()   -- 向右移动
        self:moveToRight()
    end,
   [MoveDirectionType.up]    = function()   -- 向上移动
        self:moveToUp()
    end,
   [MoveDirectionType.down]  = function()   -- 向下移动
        self:moveToDown()
   end, 
    }
end

--通过传入的方向 去停止移动 并执行等待动作
function PlayerNode:stopMoveByState(direction)
  switch(direction) : caseof
  {
   [MoveDirectionType.left]  = function()   -- 向左移动
        if self.nowState == MoveDirectionType.left then 
           self.nowState = MoveDirectionType.idle
           self:playAnim(AnimationType.idleL)
        end
    end,
   [MoveDirectionType.right] = function()   -- 向右移动
        if self.nowState == MoveDirectionType.right then 
           self.nowState = MoveDirectionType.idle 
           self:playAnim(AnimationType.idleR)
        end
    end,
   [MoveDirectionType.up]    = function()   -- 向上移动
        if self.nowState == MoveDirectionType.up then 
           self.nowState = MoveDirectionType.idle 
           self:playAnim(AnimationType.idleU)
        end
    end,
   [MoveDirectionType.down]  = function()   -- 向下移动
        if self.nowState == MoveDirectionType.down then 
           self.nowState = MoveDirectionType.idle 
           self:playAnim(AnimationType.idleD)
        end
   end, 
    }
end

--刷新当前的移动动画
--自动寻路的时候 使用
function PlayerNode:refreshMoveAnim(direction)
  self.nowState = direction
  switch(direction) : caseof
  {
   [MoveDirectionType.left]  = function()   -- 向左移动
        self:playAnim(AnimationType.walkL)
    end,
   [MoveDirectionType.right] = function()   -- 向右移动
        self:playAnim(AnimationType.walkR)
    end,
   [MoveDirectionType.up]    = function()   -- 向上移动
        self:playAnim(AnimationType.walkU)
    end,
   [MoveDirectionType.down]  = function()   -- 向下移动
        self:playAnim(AnimationType.walkD)
   end, 
    }
end

--获得角色当前的tiledMap坐标
function PlayerNode:getTiledMapPos( )
    return self.parentScene:tileCoordForPosition(cc.p(self:getPosition()))
end

--这里传进来的 坐标 需要是 tiledMap的坐标
function PlayerNode:moveToPos(targetTiledPos)
    if self.parentScene:targetPosIsBarrier(targetTiledPos) then 
       self:stopAllActions()

       local targetWorldPos = self.parentScene:positionForTileCoord(targetTiledPos)
       local moveTo = cc.MoveTo:create(0.2,targetWorldPos)
       
       local sequence = cc.Sequence:create(moveTo,cc.CallFunc:create(function()
                                                  self:_refreshState() 
                                                  end))
       self:runAction(sequence)
    else

       --self.isMoving = true
    end
end


--普通向左移动
function PlayerNode:moveToLeft()
   local pos = self:getTiledMapPos()
   local targetTiledPos = cc.p(pos.x-1,pos.y)
   self:moveToPos(targetTiledPos)
   
end

--普通向右移动
function PlayerNode:moveToRight()
	 local pos = self:getTiledMapPos()
   local targetTiledPos = cc.p(pos.x+1,pos.y)
   self:moveToPos(targetTiledPos)
end

--普通向上移动
function PlayerNode:moveToUp()
   local pos = self:getTiledMapPos()
   local targetTiledPos = cc.p(pos.x,pos.y-1)
   self:moveToPos(targetTiledPos)
end

--普通向下移动
function PlayerNode:moveToDown()
	 local pos = self:getTiledMapPos()
   local targetTiledPos = cc.p(pos.x,pos.y+1)
   self:moveToPos(targetTiledPos)
end

--[[
    动画规格类型  静止图 上下左右各1 行走图 上下左右各2 吞噬图 ？ 释放技能图 ？ 死亡图 ？
    这里需要对所有的 角色进行一个名称规范
    怪物表格里面 增加一列 资源名称 
    比如 骷髅怪 一列  资源名称  Skeleton_%s_%d.png
                      动画名称  Skeleton_
]]
function PlayerNode:initAnim(resName,animName)
    self.animNameList = {}

    local animationNames = {"idleD","idleL","idleR","idleU","walkD","walkL", "walkR", "walkU"}
    local animationFrameNum = {1,1,1,1,2,2,2,2}
   
    for i = 1, #animationNames do
        local str = string.format(resName,i)
        local frames = AnimationCacheFunc.newFrames(str.."_%d.png", 1, animationFrameNum[i])
        local animation = AnimationCacheFunc.newAnimation(frames, 0.2)
        local animationName = animName..animationNames[i]
        table.insert(self.animNameList,i,animationName)
        AnimationCacheFunc.setAnimationCache(animation,animationName)
    end
end

function PlayerNode:playAnim( animType )
    AnimationCacheFunc.playAnimationForever(self.sprite, AnimationCacheFunc.getAnimationCache(self.animNameList[animType]))
end

--根据下一个坐标点来判断需要执行什么样的动作动画
function PlayerNode:decideDirection(nextPos)
    local nowPos = cc.p(self:getPosition())

    local state = MoveDirectionType.idle
    --这里因为具体的坐标点 要么 x坐标相同 要么y坐标相同 因此 可以用这样的方法
    if nowPos.x > nextPos.x then 
       state = MoveDirectionType.left
    elseif nowPos.x < nextPos.x then
       state = MoveDirectionType.right 
    elseif nowPos.y > nextPos.y then
       state = MoveDirectionType.down
    elseif nowPos.y < nextPos.y then
       state = MoveDirectionType.up
    end 

    --如果 方向没有发生改变  则不改变动画
    if self.nowState ~= state then 
       self:refreshMoveAnim(state)
    end
end

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
    
    
    状态 (暂定)
    state:

	    idle    待机 
	    walk    走路(暂时不用这些状态)
	    --run     跑动
	    jump    跳跃
	    squat   下蹲
	    roll    滚动
	    attack  攻击
	    defend  防守
	    climb   攀爬
	    skill   特殊技能
	    

    事件
    event:

	    isJump    我要跳
	    isDrop    我要下降
	    isAttack  我要攻击
	    isSkill   我要放技能


	逻辑整理：
	isJump   在 { idle walk run climb } 可以进行 jump 
    isAttack 在 { "idle","walk","jump","run","defend","drop" } 可以进行 attack
    isSkill  在 { "idle","walk","jump","run","defend","drop" } 可以进行 skill

    关于重力：

    drop 只有在 isJump 时 关闭，其他事件都打开（以后特殊场景除外）

]]
function PlayerNode:initStateMachine( )
	self.fsm = StateMachine.new()

	self.fsm:setupState({
		initial = "idle",
		events = {
		          {name = "stop",     from = {"walk","jump","defend","attack","skill","drop"}, to = "idle"},
		          {name = "isWalk",   from = {"jump","defend","attack","skill","drop","idle"}, to = "walk"},
		          {name = "isJump",   from = {"walk","idle","climb"},                          to = "jump" },
			      {name = "isAttack", from = {"walk","idle","jump","defend","drop"},           to = "attack"},
			      {name = "isSkill",  from = {"walk","idle","jump","defend"},                  to = "skill"},
			      {name = "isDrop",   from = {"jump"},                                         to = "drop"},
			    },
        callbacks = {
				   onbeforestart = function(event) print("[FSM] STARTING UP") end,
				   onstart = function(event) print("[FSM] READY") end,
				   --在跳跃之前执行事件 关闭重力
				   onbeforeisJump = function(event) self:openOrColseGravity(false) end,				    
				   --跳跃结束之后执行事件 开启重力
				   onafterisJump  = function(event)  end,       
                   onenterjump = function(event) self:jump() end,--self:openOrColseGravity(false) end,
                   onleavejump = function(event)  end,--self:openOrColseGravity(false) end,
				   onenteridle = function(event)  end,
				   onenterdrop = function(event) self:openOrColseGravity(true) end,
				   onenteridle = function(event) print("onenteridle") self:enterIdle() end,
				   onenterwalk = function(event) print("onenterwalk") self:enterWalk() end,
			    },
	})
end



--转换状态
function PlayerNode:doEvent(event,...)
	--dump(self:canDoEvent(event))
	if self:canDoEvent(event) == true then
       self.fsm:doEvent(event,...)
    end
end

--强制转换
function PlayerNode:doEventForce(event,...)
	self.fsm:doEventForce(event,...)
end

--当前状态如果能完成eventName对应的event的状态转换，则返回true
function PlayerNode:canDoEvent(event,...)
	return self.fsm:canDoEvent(event,...)
end

--当前状态如果不能完成eventName对应的event的状态转换，则返回true
function PlayerNode:cannotDoEvent(event,...)
	return self.fsm:cannotDoEvent(event,...)
end

function PlayerNode:getState()
	return self.fsm:getState()
end


--************************************************自动寻路模块 开始*************************************************--

--===========================ShortestPathStep=========================
--A*算法 记录GHF值的类
local ShortestPathStep = class("ShortestPathStep")

function ShortestPathStep:ctor()
	self._position = cc.p(0,0)
	self._gScore = 0
	self._hScore = 0
	self._parent = nil
end

function ShortestPathStep:setPosition(position)
	self._position = position
end

function ShortestPathStep:getPosition()
	return self._position
end 

function ShortestPathStep:setGScore(gScore)
	self._gScore = gScore
end

function ShortestPathStep:getGScore()
	return self._gScore
end

function ShortestPathStep:setHScore(hScore)
	self._hScore = hScore
end

function ShortestPathStep:getHScore()
	return self._hScore
end

function ShortestPathStep:setParent(parent)
	self._parent = parent
end

function ShortestPathStep:getParent()
	return self._parent
end



function ShortestPathStep:getFScore()
	return self:getGScore() + self:getHScore()
end

function ShortestPathStep:isEqual(other)

	return (self:getPosition().x == other:getPosition().x) and (self:getPosition().y == other:getPosition().y)

end
--[[
function ShortestPathStep:getDescription()
	return string.char(
		self:getPosition().x, self:getPosition().y,
		GScore, HScore, FScore)
end
--]]

--==================================ShortestPathStep==================

--==================================寻路过程开始==========================

function PlayerNode:moveToward(target)
    
    self:stopActionByTag(1)

    --获得当前的起点和终点坐标
    local fromTileCoord =self.parentScene:tileCoordForPosition(cc.p(self:getPosition()))
    --cc.p(self:getPosition())   self:getPosition()给的是一个数值 所以需要cc.p()
    local toTileCoord = target--self.tileMap:tileCoordForPosition(target)

    
    --设置一个私有成员，方便下面的方法使用
	  self._toTileCoord = toTileCoord



	  print("From: "..fromTileCoord.x,fromTileCoord.y)
  	print("To: "..toTileCoord.x,toTileCoord.y)
    
    --两个表清空
    self.spOpenSteps = {}
    self.spClosedSteps = {}

    --添加角色初始坐标到open table  
    local Step = ShortestPathStep.new()
    Step:setPosition(fromTileCoord)
    self:insertInOpenSteps(Step)
    
    repeat
      --将起点赋值给currentStep这个临时变量 
      local currentStep = self.spOpenSteps[1]

      --print("Open1")
      --dump(self.spOpenSteps)
      --print("Open #")
      
      --判断Close里是否已经添加，没有添加则往后依次添加起点（当前点)坐标
      local a
      local k = #self.spClosedSteps + 1 
      for a = 1 ,k,1  do 
        if self.spClosedSteps[a] ~= nil then
          a=a+1
        else
           table.insert(self.spClosedSteps,a,currentStep)
           break
        end
      end 
      --print("close")
      --dump(self.spClosedSteps)
      --print("close #")


      --将起点从Open表中删除
      table.remove(self.spOpenSteps,1)

      --print("Open2")
      --dump(self.spOpenSteps)
      --print("Open #")

      --print("找到路径")
      if (currentStep:getPosition().x == self._toTileCoord.x and currentStep:getPosition().y == self._toTileCoord.y) then  
        self:constructPathAndStartAnimationFromStep(currentStep)
        self.spOpenSteps = {}
        self.spClosedSteps = {}
        break
      end

      
      --获得当前点的 上下左右坐标，并判断是否满足条件，并加入Open表中

      local abjSteps = self:walkableAdjacentTilesCoordForTileCoord(cc.p(currentStep:getPosition()))
      for k,v in ipairs(abjSteps) do 
          step = ShortestPathStep.new()
          local pos = v 
          
          step:setPosition(pos)
          if self:getStepIndex(self.spClosedSteps,step) ~= -1 then 
                  
                  
          else
              local moveCost = 1 
              local index = self.getStepIndex(self.spOpenSteps,step)

              if index == -1 then 
                step:setParent(currentStep)
                step:setGScore(currentStep:getGScore()+moveCost)
                local hscore = self:computeHScoreFromCoordToCoord(cc.p(step:getPosition()),self._toTileCoord)
                --print("hscore : "..hscore )
                step:setHScore(hscore)
                --dump(step)           
                self:insertInOpenSteps(step)
                
                else 
                  local stepOpenList = self.spOpenSteps[index]
                   if currentStep:getGScore() + moveCost < stepOpenList:getGScore() then 
                    stepOpenList:setGScore(currentStep:getGScore() + moveCost)
                    stepOpenList:retain()
                    table.remove(self.spOpenSteps,index)
                    --print("here")
                    self:insertInOpenSteps(stepOpenList)
                    stepOpenList:release()
                   end 
                end 
          end 

      end  
    until #self.spOpenSteps <= 0	
end


function PlayerNode:walkableAdjacentTilesCoordForTileCoord(tileCoord)
  local tmp = {} 
  --up
  local p = cc.p(tileCoord.x, tileCoord.y - 1)

  if self.parentScene:targetPosIsBarrier(p) then 
    
    table.insert(tmp,p)
    
  end 
  --left
  p = cc.p(tileCoord.x-1, tileCoord.y)
  if self.parentScene:targetPosIsBarrier(p) then 
    
    table.insert(tmp,p)
    
  end 
  -- down
  p = cc.p(tileCoord.x, tileCoord.y + 1)
  if self.parentScene:targetPosIsBarrier(p) then 
    
    table.insert(tmp,p)
    
  end
  -- right
  p = cc.p(tileCoord.x + 1, tileCoord.y)
  if self.parentScene:targetPosIsBarrier(p) then 
    table.insert(tmp,p)
    
  end 

  return tmp
 
end


function PlayerNode:insertInOpenSteps(step)
   
    local stepFScore = step:getFScore()
    local count = #self.spOpenSteps + 1
    local j=1 
    for i=1,count do
        local s = self.spOpenSteps[i]
        j = i
        if s then  
           if stepFScore <= s:getFScore() then
              break
           end
            
        end  
    end
    table.insert(self.spOpenSteps,j,step)
    
end
	

function PlayerNode:computeHScoreFromCoordToCoord(fromCoord,toCoord)
return  math.abs(toCoord.x - fromCoord.x) + math.abs(toCoord.y - fromCoord.y)
end

--function PlayerNode:costToMoveFromStepToAdjacentStep (fromStep,toStep) 
--	return 1
--end

function PlayerNode:getStepIndex(steps,step)
	
    local k = #steps +1  
    for i= 1, k do
    	if steps[i]~= nil then
       
    		if steps[i]:isEqual(step) then 
    			--print("i:"..i)
    			return i
    		end 
      end 
    end 
	return -1 
end


function PlayerNode:constructPathAndStartAnimationFromStep(step)

	self.shortestPath = {}
  
    repeat
      if step:getParent() then 
      table.insert(self.shortestPath,1,step)
      end
      step = step:getParent() 

    until step == nil 

	self:popStepAndAnimate()

end 

function PlayerNode:popStepAndAnimate()

    --当前点的坐标
    local _playerP = self.parentScene:tileCoordForPosition(cc.p(self:getPosition()))

    --到达目标点
    if _playerP.x == self._toTileCoord.x and _playerP.y == self._toTileCoord.y then 

      --目前什么都不执行
      
      -- if math.abs(math.abs(toTileCoordTar.x- _playerP.x)+math.abs(toTileCoordTar.y - _playerP.y)) <= 1 then 

      -- elseif self.parentScene:isOreAtTileCoord(toTileCoordTarUp) and  not self.parentScene:isBlankAtTileCoord(toTileCoordTarUp)  then
              
      -- elseif self.parentScene:isHPAtTileCoord(toTileCoordTarUp) and  not self.parentScene:isBlankAtTileCoord(toTileCoordTarUp)  then
          
      -- end
    end
  
    --判断步骤全部完成
    local shortSize = #self.shortestPath + 1  
    if shortSize == 1 then 
       self:stopMoveByState(self.nowState)
       return
    end 
 
    --分步完成移动,执行moveTo
    s = ShortestPathStep.new()
    s = self.shortestPath[1]

    --需要判断一下 下一步的移动方向 从而改变当前人物的移动状态
    self:decideDirection(cc.p(self.parentScene:positionForTileCoord(cc.p(s:getPosition()))))
   
    local sequence = cc.Sequence:create(
     cc.MoveTo:create(0.2, cc.p(self.parentScene:positionForTileCoord(cc.p(s:getPosition())).x,self.parentScene:positionForTileCoord(cc.p(s:getPosition())).y)),
    
    cc.CallFunc:create(function()
    self:popStepAndAnimate()
    end)
    )
    
    sequence:setTag(1)
    self:runAction(sequence)

    table.remove(self.shortestPath,1)

end
--==================================寻路过程结束==========================

--************************************************自动寻路模块 结束*************************************************--