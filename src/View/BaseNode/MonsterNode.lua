--
-- Author: HLZ
-- Date: 2016-04-22 16:24:13
-- 怪兽节点封装

MonsterNode = class("MonsterNode",function ()
	return cc.Node:create()
end)

MonsterNode.__index = MonsterNode


--[[
    怪兽的通用的继承节点
    主要功能用：
               自动寻路

]]

function MonsterNode:ctor()
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
    
    --动画名称列表
    self.animNameList = {}

  	--相机
  	--self.camera = nil 

    --初始精灵节点
    self.sprite = nil 

    --初始化 动作状态 
    self.nowState = MoveDirectionType.idle

    self.isMoving = false
    
    self.parentScene = mtBattleMgr():getScene()

  	self:setName(self.__cname)

  	-- local body = cc.PhysicsBody:createBox(self:getContentSize(), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
   --    self:setPhysicsBody(body)

end

function MonsterNode:dispatchEvent(event,data)
	   mtEventDispatch():dispatchEvent(event,data)
end


function MonsterNode:registerEvent( event,callBack,groupID,priority )
  	--将事件加入数组，方便在退出的时候将侦听事件给移除掉
  	self.eventListeners = self.eventListeners or {}
  	self.eventListeners[#self.eventListeners + 1] = mtEventDispatch():registerEvent(event,callBack,groupID,priority)
  	return self.eventListeners[#self.eventListeners + 1]
end

function MonsterNode:onExit( )
  	if self.eventListeners == nil then
  		return 
  	end
  	--统一对事件数组里面的时间进行释放
  	for i,v in ipairs(self.eventListeners) do
  		mtEventDispatch():removeEvent(v)
  	end	
end

function MonsterNode:onEnter( )
	
end

function MonsterNode:onHide(  )
	
end

--设置 技能的释放范围
-- function MonsterNode:setSkillRangeDiagram(diagram)
--     self.diagram = diagram
--     self.diagram:setAnchorPoint(cc.p(0.4,1))
--     --local size = self:getContentSize()
--     self.diagram:setPosition(cc.p(0,-50))
--     self:addChild(diagram,10)
-- end


--获得角色当前的tiledMap坐标
function MonsterNode:getTiledMapPos( )
    return self.parentScene:tileCoordForPosition(cc.p(self:getPosition()))
end


--通过传入的方向 去停止移动 并执行等待动作
function MonsterNode:stopMoveByState(direction)
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
function MonsterNode:refreshMoveAnim(direction)
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

--[[
    动画规格类型  静止图 上下左右各1 行走图 上下左右各2 吞噬图 ？ 释放技能图 ？ 死亡图 ？
    这里需要对所有的 角色进行一个名称规范
    怪物表格里面 增加一列 资源名称 
    比如 骷髅怪 一列  资源名称  Skeleton_%d
                      动画名称  Skeleton_
]]
function MonsterNode:initAnim(resName,animName)
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

function MonsterNode:playAnim( animType )
    AnimationCacheFunc.playAnimationForever(self.sprite, AnimationCacheFunc.getAnimationCache(self.animNameList[animType]))
end

function MonsterNode:initMonsterInfo(  )
    --每一次移动的距离 公共配置
    self.pix = g_Config:getData(GameConfig.addConfig["Common"])[1].PixelSpec
    --怪兽的速度 【在程序里是指 移动完一格的时间】
    self.monsterVelocity = self.pix/self.monsterLogic:getMonsterData():getMonsterVelocity()
    
end

--根据下一个坐标点来判断需要执行什么样的动作动画
function MonsterNode:decideDirection(nextPos)
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

--强制停止寻路
function MonsterNode:stopMoveToward( )
   self:stopActionByTag(1)
   
   --self:stopMoveByState(self.nowState)

   --两个表清空
   self.spOpenSteps = {}
   self.spClosedSteps = {}

   self.shortestPath = {}

end

--target 目标点坐标
--callBack 最终的回调
--callBackStep 分步回调
function MonsterNode:moveToward(target,callBack,callBackStep)

    self:stopActionByTag(1)

    --获得当前的起点和终点坐标
    local fromTileCoord =self.parentScene:tileCoordForPosition(cc.p(self:getPosition()))
    --cc.p(self:getPosition())   self:getPosition()给的是一个数值 所以需要cc.p()
    local toTileCoord = target--self.tileMap:tileCoordForPosition(target)

    
    --设置一个私有成员，方便下面的方法使用
	  self._toTileCoord = toTileCoord



	  --print("From: "..fromTileCoord.x,fromTileCoord.y)
  	--print("To: "..toTileCoord.x,toTileCoord.y)
    
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
        self:constructPathAndStartAnimationFromStep(currentStep,callBack,callBackStep)
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


function MonsterNode:walkableAdjacentTilesCoordForTileCoord(tileCoord)
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


function MonsterNode:insertInOpenSteps(step)
   
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
	

function MonsterNode:computeHScoreFromCoordToCoord(fromCoord,toCoord)
return  math.abs(toCoord.x - fromCoord.x) + math.abs(toCoord.y - fromCoord.y)
end

--function MonsterNode:costToMoveFromStepToAdjacentStep (fromStep,toStep) 
--	return 1
--end

function MonsterNode:getStepIndex(steps,step)
	
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


function MonsterNode:constructPathAndStartAnimationFromStep(step,callBack,callBackStep)

	self.shortestPath = {}
  
    repeat
      if step:getParent() then 
      table.insert(self.shortestPath,1,step)
      end
      step = step:getParent() 

    until step == nil 

	self:popStepAndAnimate(callBack,callBackStep)

end 

function MonsterNode:popStepAndAnimate(callBack,callBackStep)

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
       --self:stopMoveByState(self.nowState)
       if callBack ~= nil then 
          callBack()
       end
       return
    end 
 
    --分步完成移动,执行moveTo
    s = ShortestPathStep.new()
    s = self.shortestPath[1]

    --需要判断一下 下一步的移动方向 从而改变当前人物的移动状态
    self:decideDirection(cc.p(self.parentScene:positionForTileCoord(cc.p(s:getPosition()))))
    
    --速度可能会随时变化，所以每次都要重新获取新的速度  t = s / v  
    self.monsterVelocity = self.pix/self.monsterLogic:getMonsterData():getMonsterVelocity()

    local sequence = cc.Sequence:create(
     cc.MoveTo:create(self.monsterVelocity, cc.p(self.parentScene:positionForTileCoord(cc.p(s:getPosition())).x,self.parentScene:positionForTileCoord(cc.p(s:getPosition())).y)),
    
    cc.CallFunc:create(function()
      --加入每一步执行完后的回调 
      if callBackStep ~= nil then 
         if callBackStep() == false then 
            self:popStepAndAnimate(callBack,callBackStep)
         end
      else
         self:popStepAndAnimate(callBack,callBackStep)
      end
      
    end)
    )
    
    sequence:setTag(1)
    self:runAction(sequence)

    table.remove(self.shortestPath,1)

end
--==================================寻路过程结束==========================

--************************************************自动寻路模块 结束*************************************************--