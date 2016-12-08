--
-- Author: HLZ
-- Date: 2016-01-07 14:01:52
-- 封装一个含有TiledMap场景
-- 封装含有物理引擎的场景

local BattleScene = class("BattleScene", function (  )
	return cc.Scene:create() --cc.Scene:createWithPhysics()
end)




--[[
    继承于 EventScene的类，需要在ctor() onEnter() onExit() 加上 .super.ctor(self)类似的方法 
--]]

function BattleScene:ctor()
	
	--当前场景监听的事件数组
	self.eventListeners = {}

	self.tiledMap = nil 

	self.player = nil 
    
    --获取场景绑定的物理世界对象
	--self.world = self:getPhysicsWorld()
    
    --设置物理世界重力
	--self.world:setGravity(cc.p(0,0))
    
    --设置Debug模式
	--self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    
    --进入时，调用onEnter() 
    --退出时，调用onExit()
	self:registerScriptHandler(function ( event )
		if event == "enter" then
			self:onEnter()
		elseif event == "exit" then
			self:onExit()
		end
	end)
    
	self:setName(self.__cname)
	--poi?
	--self.hasPoped = false
end

function BattleScene:dispatchEvent(event,data)
	mtEventDispatch():dispatchEvent(event,data)
end

function BattleScene:registerEvent( event,callBack,groupID,priority )
	--将事件加入数组，方便在退出的时候将侦听事件给移除掉
	self.eventListeners = self.eventListeners or {}
	self.eventListeners[#self.eventListeners + 1] = mtEventDispatch():registerEvent(event,callBack,groupID,priority)
	return self.eventListeners[#self.eventListeners + 1]
end

function BattleScene:onExit( )
	if self.eventListeners == nil then
		return 
	end
	--统一对事件数组里面的时间进行释放
	for i,v in ipairs(self.eventListeners) do
		mtEventDispatch():removeEvent(v)
	end

	self:removeTouchListener()
	--self:_removeTimer();
	
end

function BattleScene:onEnter( )
	
end

function BattleScene:onHide(  )
	
end

--创建TiledMap
function BattleScene:createTMXTM(file)
	if self.tiledMap == nil then 
	   self.tiledMap = cc.TMXTiledMap:create(file)
    end

    self.maxWidth = self.tiledMap:getContentSize().width - GameUtil:VISIBLE_WIDTH()/2
    self.maxHeight = self.tiledMap:getContentSize().height - GameUtil:VISIBLE_HEIGHT()/2

    return self.tiledMap
end

function BattleScene:getLayer(layerName)
	local layer = self.tiledMap:getLayer(layerName)
	if layerName == TiledMapLayer.barrier then 
	   self.impactLayer = layer
	end
    return layer
end


  --转tilemap地图      从世界地图坐标转到TiledMap地图坐标
function BattleScene:tileCoordForPosition(position) 
	local x = math.floor(position.x / self.tiledMap:getTileSize().width)
	local y = math.floor(((self.tiledMap:getMapSize().height * self.tiledMap:getTileSize().height)-position.y) / self.tiledMap:getTileSize().height)
	return cc.p(x,y)
end

  --转正常地图         从TiledMap地图坐标转到世界地图坐标
function BattleScene:positionForTileCoord(tileCoord)
	local x = math.floor((tileCoord.x * self.tiledMap:getTileSize().width) + self.tiledMap:getTileSize().width / 2)
	local y = math.floor((self.tiledMap:getMapSize().height * self.tiledMap:getTileSize().height) -
		(tileCoord.y * self.tiledMap:getTileSize().height) - self.tiledMap:getTileSize().height / 2)
	return cc.p(x, y)
end




--[[
    不再使用相机移动，而是整个self.map进行移动 
    移动的公式:
    playerPosX >= GameUtil:VISIBLE_WIDTH()/2 and playerPosX <= self.map:getContentSize().width - GameUtil:VISIBLE_WIDTH()/2
]]



function BattleScene:refreshMapPos(distanceX,distanceY)
    
    --判断是否需要移动 并且判断方向
    local playerPosX = self.player:getPositionX()
    local playerPosY = self.player:getPositionY()
    
    --移动范围
    if playerPosX >= GameUtil:VISIBLE_WIDTH()/2 and playerPosX <= self.map:getContentSize().width - GameUtil:VISIBLE_WIDTH()/2 then 
    --角色向左移动的时候 地图向右移动
	    if distanceX < 0 then 
	       --print("右")
	       self:setMapPosX(1,math.abs(distanceX))
	    --角色向右移动的时候 地图向左移动
	    elseif distanceX > 0 then
	    	--print("左")
	       self:setMapPosX(-1,math.abs(distanceX))
	    end
    end

     if playerPosY >= GameUtil:VISIBLE_HEIGHT()/2 and playerPosY <= self.map:getContentSize().height - GameUtil:VISIBLE_HEIGHT()/2 then 
    --角色向左移动的时候 地图向右移动
	    if distanceY < 0 then 
	       --print("下")
	       self:setMapPosY(1,math.abs(distanceY))
	    --角色向右移动的时候 地图向左移动
	    elseif distanceY > 0 then
	    	--print("上")
	       self:setMapPosY(-1,math.abs(distanceY))
	    end
    end

end

--初始化地图位置
function BattleScene:initMapPos()

	--判断是否需要移动 并且判断方向
    local playerPosX = self.player:getPositionX()
    local playerPosY = self.player:getPositionY()

    local distanceX = 0
    local distanceY = 0

    if playerPosX >= GameUtil:VISIBLE_WIDTH()/2 and playerPosX <= self.map:getContentSize().width - GameUtil:VISIBLE_WIDTH()/2 then 
       distanceX = playerPosX - GameUtil:VISIBLE_WIDTH()/2
       self:setMapPosX(-1,math.abs(distanceX))
    elseif playerPosX >= self.map:getContentSize().width - GameUtil:VISIBLE_WIDTH()/2 then 
       distanceX = self.map:getContentSize().width - GameUtil:VISIBLE_WIDTH()
       self:setMapPosX(-1,math.abs(distanceX))
    end

    if playerPosY >= GameUtil:VISIBLE_HEIGHT()/2 and playerPosY <= self.map:getContentSize().height - GameUtil:VISIBLE_HEIGHT()/2 then 
       distanceY = playerPosY - GameUtil:VISIBLE_HEIGHT()/2
       self:setMapPosY(-1,math.abs(distanceY))
    elseif playerPosY >= self.map:getContentSize().height - GameUtil:VISIBLE_HEIGHT()/2 then 
       distanceY = self.map:getContentSize().height - GameUtil:VISIBLE_HEIGHT()
       self:setMapPosY(-1,math.abs(distanceY))
    end
    
end

--移动地图X轴
function BattleScene:setMapPosX(direction,x)
	local distanceX = direction * x
	local nowPosX = self.map:getPositionX() + distanceX
	if ((nowPosX < GameUtil:VISIBLE_WIDTH() - self.map:getContentSize().width) and direction == -1 ) or ((nowPosX > 0) and direction == 1 ) then 
	    return 
	end
	self.map:setPositionX(nowPosX)
end

--移动地图Y轴
function BattleScene:setMapPosY(direction,y)
	local distanceY = direction * y
	local nowPosY = self.map:getPositionY() + distanceY
	if ((nowPosY < GameUtil:VISIBLE_HEIGHT() - self.map:getContentSize().height) and direction == -1 ) or ((nowPosY > 0) and direction == 1 ) then 
	    return 
	end
    self.map:setPositionY(nowPosY)
end

function BattleScene:targetPosIsBarrier(targetPos)
    --如果传进来的坐标，不在地图上，是否会报错？
    local maxWidth = self.tiledMap:getMapSize().width-1
    local maxHeight = self.tiledMap:getMapSize().height-1
    if targetPos.x < 0 or targetPos.x > maxWidth or targetPos.y < 0 or targetPos.y > maxHeight then 
       return false
    else
        local gid = self.impactLayer:getTileGIDAt(targetPos)
	    if gid == 0 then 
	       return true
	    else             --现在其他的都先默认是墙，以后可以扩展
	       return false
	    end
    end
    return false
end


--初始化键盘响应事件
function BattleScene:initKeyBoardListener()
        --按下事件
	    local function keyboardPressed(keyCode, event)
	        if keyCode == cc.KeyCode.KEY_LEFT_ARROW then
	            self:pressedLeftBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_RIGHT_ARROW then
	            self:pressedRightBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_UP_ARROW then
	            self:pressedUpBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_DOWN_ARROW then
	            self:pressedDownBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_S then   --吞噬键
	        	self:pressedDevourBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_A then   --技能A键
	        	self:pressedSkillABtnListener()
	        elseif keyCode == cc.KeyCode.KEY_W then   --技能B键
                self:pressedSkillBBtnListener()
            elseif keyCode == cc.KeyCode.KEY_D then   --技能C键
                self:pressedSkillCBtnListener()
	        end
	        -- print("keyCode = "..tostring(keyCode))
	        -- print("event = "..tostring(event))
	        -- print(cc.KeyCode.KEY_C)
        end
        
        --松开事件
        local function keyboardReleased(keyCode, event)
	        if keyCode == cc.KeyCode.KEY_LEFT_ARROW then
	            self:releasedLeftBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_RIGHT_ARROW then
	            self:releasedRightBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_UP_ARROW then
	            self:releasedUpBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_DOWN_ARROW then
	            self:releasedDownBtnListener()
            elseif keyCode == cc.KeyCode.KEY_S then   --吞噬键
	        	self:releasedDevourBtnListener()
	        elseif keyCode == cc.KeyCode.KEY_A then   --技能A键
	        	self:releasedSkillABtnListener()
	        elseif keyCode == cc.KeyCode.KEY_W then   --技能B键
                self:releasedSkillBBtnListener()
            elseif keyCode == cc.KeyCode.KEY_D then   --技能C键
                self:releasedSkillCBtnListener()
	        end
	        -- print("keyCode = "..tostring(keyCode))
	        -- print("event = "..tostring(event))
        end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(keyboardPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(keyboardReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)
    

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
    self._listener = listener

end

function BattleScene:removeTouchListener(  )
	if self._listener then 
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:removeEventListener(self._listener)
		self._listener = nil
    end
end


function BattleScene:pressedLeftBtnListener()
	if self.player ~= nil then 
       self.player:refreshState(MoveDirectionType.left)
    end
end

function BattleScene:pressedRightBtnListener()
	if self.player ~= nil then 
       self.player:refreshState(MoveDirectionType.right) 
    end
end

function BattleScene:pressedUpBtnListener()
	if self.player ~= nil then 
       self.player:refreshState(MoveDirectionType.up) 
    end
end

function BattleScene:pressedDownBtnListener()
	if self.player ~= nil then 
       self.player:refreshState(MoveDirectionType.down) 
    end
end

--按下显示技能范围 松开则释放 并删除显示范围
function BattleScene:pressedDevourBtnListener()
    if self.player ~= nil then 
       local skill = self.player:getLogic():getDevourSkill()
       if skill ~= nil then 
          skill:showSkillRangeDiagram(self.player)
       end
    end
end

function BattleScene:pressedSkillABtnListener()
    if self.player ~= nil then 
       local skill = self.player:getLogic():getFlowSkillByIndex(1)
       if skill ~= nil then 
          skill:showSkillRangeDiagram(self.player)
       end
    end
end

function BattleScene:pressedSkillBBtnListener()
	if self.player ~= nil then 
       local skill = self.player:getLogic():getFlowSkillByIndex(2)
       if skill ~= nil then 
          skill:showSkillRangeDiagram(self.player)
       end
    end
end

function BattleScene:pressedSkillCBtnListener()
	if self.player ~= nil then 
       local skill = self.player:getLogic():getFlowSkillByIndex(3)
       if skill ~= nil then 
          skill:showSkillRangeDiagram(self.player)
       end
    end
end

--松开事件
function BattleScene:releasedLeftBtnListener()
	if self.player ~= nil then 
	   self.player:stopMoveByState(MoveDirectionType.left)
    end
end
function BattleScene:releasedRightBtnListener()
	if self.player ~= nil then 
       self.player:stopMoveByState(MoveDirectionType.right)
    end
end
function BattleScene:releasedUpBtnListener()
	if self.player ~= nil then 
       self.player:stopMoveByState(MoveDirectionType.up)
    end
end
function BattleScene:releasedDownBtnListener()
	if self.player ~= nil then 
       self.player:stopMoveByState(MoveDirectionType.down)
    end
end

function BattleScene:releasedDevourBtnListener(isUseSkill)
	if self.player ~= nil then 
	   local skill = self.player:getLogic():getDevourSkill()
	   if skill ~= nil then 
		  skill:hideSkillRangeDiagram()
		  if isUseSkill ~= false then 
	         self.player:getLogic():devourMonster()
	      end
       end
    end
end

function BattleScene:releasedSkillABtnListener(isUseSkill)
    if self.player ~= nil then 
        local skill = self.player:getLogic():getFlowSkillByIndex(1)
        if skill ~= nil then 
	       skill:hideSkillRangeDiagram()
	       if isUseSkill ~= false then 
	          skill:launch(self.player,1)
	       end
        end
    end
end

function BattleScene:releasedSkillBBtnListener(isUseSkill)
	if self.player ~= nil then 
        local skill = self.player:getLogic():getFlowSkillByIndex(2)
        if skill ~= nil then 
	       skill:hideSkillRangeDiagram()
	       if isUseSkill ~= false then 
	          skill:launch(self.player,2)
	       end
        end
    end
end

function BattleScene:releasedSkillCBtnListener(isUseSkill)
	if self.player ~= nil then 
        local skill = self.player:getLogic():getFlowSkillByIndex(3)
        if skill ~= nil then 
	       skill:hideSkillRangeDiagram()
	       if isUseSkill ~= false then 
	          skill:launch(self.player,3)
	       end
        end
    end
end

return BattleScene
--[[

    用的到的一些TiledMap地图的方法 

    设置一个地图块:     layer:setTileGID(GID, cc.p(x,y)) 
    获得一个地图块的GID layer:getTileGIDAt(cc.p(x,y))
    移除一个地图块：    layer:removeTileAt(cc.p(x,y))
    获得当前地图的每块地图的长宽  getMapSize().height   getMapSize().width
   
--]]


