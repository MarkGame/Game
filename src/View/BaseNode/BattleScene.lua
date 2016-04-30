--
-- Author: HLZ
-- Date: 2016-01-07 14:01:52
-- 封装一个含有TiledMap场景
-- 封装含有物理引擎的场景

BattleScene = class("BattleScene", function (  )
	return cc.Scene:createWithPhysics()
end)
BattleScene.__index = BattleScene



--[[
    继承于 EventScene的类，需要在ctor() onEnter() onExit() 加上 .super.ctor(self)类似的方法 
--]]

function BattleScene:ctor()
	
	--当前场景监听的事件数组
	self.eventListeners = {}

	self.tiledMap = nil 

	self.player = nil 
    
    --获取场景绑定的物理世界对象
	self.world = self:getPhysicsWorld()
    
    --设置物理世界重力
	self.world:setGravity(cc.p(0,0))
    
    --设置Debug模式
	self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    
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
	g_EventDispatch:dispatchEvent(event,data)
end

function BattleScene:registerEvent( event,callBack,groupID,priority )
	--将事件加入数组，方便在退出的时候将侦听事件给移除掉
	self.eventListeners = self.eventListeners or {}
	self.eventListeners[#self.eventListeners + 1] = g_EventDispatch:registerEvent(event,callBack,groupID,priority)
	return self.eventListeners[#self.eventListeners + 1]
end

function BattleScene:onExit( )
	if self.eventListeners == nil then
		return 
	end
	--统一对事件数组里面的时间进行释放
	for i,v in ipairs(self.eventListeners) do
		g_EventDispatch:removeEvent(v)
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

 --    local sky = cc.Node:create()
	-- local bodyTop = cc.PhysicsBody:createEdgeSegment(cc.p(0, 30), cc.p(6000, 20))
	-- sky:setPhysicsBody(bodyTop)
	-- self:addChild(sky)
	 
    
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
    参数:
	[1] fieldOfView 相机视野 0~p (即 0~180 度) 之间
	[2] aspectRatio 屏幕的高宽比
	[3] nearPlane 第三个参数是与近平面的距离,请注意距离比与近平面还近的内容都不会呈现在游戏窗口中
	[4] farPlane 第四个参数是与远平面的距离，请注意距离比与远平面还远的内容都不会呈现在游戏窗口中。


	关于相机的知识：
	    默认相机的cameraFlag 为 1 
	    自己设定的相机 cameraFlag 依次增大 
	    在图形渲染的过程中 会把所有的相机能看到的图形都渲染一遍，但是这个渲染是有顺序的；
	    从cameraFlag按从大到小的顺序去渲染，所以如果想要在自己设定的相机下面去固定一个相机的话，则需要再创建一个 

	    从最底层 到 最上层 需要的相机分别是：
            不动的背景层     需要移动的TiledMap层   不需要移动的UI层
	          camera2             camera1             defaultcamera
	    cc.CameraFlag.USER2  cc.CameraFlag.USER1      cameraFlag = 1

	    =-= 如果不需要背景的话 则只需要创建一个新相机 就可以了； 如果需求是这样的话，就要创建两个新相机了；
--]]

--加入玩家
function BattleScene:setPlayer(player)
	self.player = player
	-- body
end

--创建背景相机
function BattleScene:setBackgroundCamera(node)
	
	if self.backgroundCamera == nil then

        self.backgroundCamera = cc.Camera:createPerspective(60, GameUtil:VISIBLE_WIDTH() / GameUtil:VISIBLE_HEIGHT(), 1, 1000)
        self.backgroundCamera:setCameraFlag(cc.CameraFlag.USER2)
        node:addChild(self.backgroundCamera)

        local pos3D = node:getPosition3D()

        self.backgroundCamera:setPosition3D(cc.vec3(0, 0, 550))

        self.backgroundCamera:lookAt(cc.vec3(0,0,0), cc.vec3(0,1,0))

        --初始化相机位置
        self.backgroundCamera:setPosition(cc.p(GameUtil:VISIBLE_WIDTH()/2,GameUtil:VISIBLE_HEIGHT()/2))

        node:setCameraMask(cc.CameraFlag.USER2)
    end
    
    return self.backgroundCamera

end

--创建地图相机
function BattleScene:setMapCamera(node,player)
	
	if self.mapCamera == nil then

        self.mapCamera = cc.Camera:createPerspective(60, GameUtil:VISIBLE_WIDTH() / GameUtil:VISIBLE_HEIGHT(), 1, 1000)
        self.mapCamera:setCameraFlag(cc.CameraFlag.USER1)

        node:addChild(self.mapCamera)

        local pos3D = node:getPosition3D()

        self.mapCamera:setPosition3D(cc.vec3(0, 0, 550))

        self.mapCamera:lookAt(cc.vec3(0,0,0), cc.vec3(0,1,0))
        
        node:setCameraMask(cc.CameraFlag.USER1)

        --初始化摄像机位置 根据当前主角生成的位置 来移动位置
        self:initCameraPos(player)

    end
    
    return self.mapCamera

end

--刷新玩家和相机的间距，保持一定的距离显示
--这里没有问题了 =。= 宝宝修好了
--这里的distance就以每一格来做？
function BattleScene:refreshPlayerAndCamera(distance,player)
    
	local mapCameraPosX = self.mapCamera:getPositionX()
	local mapCameraPosY = self.mapCamera:getPositionY()
    local distanceX = mapCameraPosX - player:getPositionX()
    local distanceY = mapCameraPosY - player:getPositionY()

    if math.abs(distanceX) > GameUtil:VISIBLE_WIDTH()/4 and distanceX > 0 then 
       --需要判断方向
       if player:getPositionX() < mapCameraPosX then  --在左边
       	  self:setCameraPosX(-1,math.abs(distance))
       end
    elseif math.abs(distanceX) > GameUtil:VISIBLE_WIDTH()/4 and distanceX < 0 then
        if player:getPositionX() >= mapCameraPosX then  --在右边                                                               
          self:setCameraPosX(1,math.abs(distance))
        end
    end

    if math.abs(distanceY) > GameUtil:VISIBLE_HEIGHT()/4 and distanceY > 0 then 
       --需要判断方向
       if player:getPositionY() < mapCameraPosY then    --在下边
          self:setCameraPosY(-1,math.abs(distance))
       end
    elseif math.abs(distanceY) > GameUtil:VISIBLE_HEIGHT()/4 and distanceY < 0 then
        if player:getPositionY() >= mapCameraPosY then  --在上边                                                             
          self:setCameraPosY(1,math.abs(distance))
        end
    end
   
end

--初始化摄像机位置
function BattleScene:initCameraPos(player)
	local initX = player:getPositionX()
	local initY = player:getPositionY()
    
    --不能超出范围
	if initX < GameUtil:VISIBLE_WIDTH()/2 then 
	   initX = GameUtil:VISIBLE_WIDTH()/2 
	elseif initX > self.maxWidth then
	   initX = self.maxWidth
	end

	if initY < GameUtil:VISIBLE_HEIGHT()/2 then 
	   initY = GameUtil:VISIBLE_HEIGHT()/2 
	elseif initY > self.maxHeight then
	   initY = self.maxHeight
	end
	
	self.mapCamera:setPosition(cc.p(initX,initY))

end

--移动地图相机X轴
function BattleScene:setCameraPosX(direction,x)
	local distanceX = direction * x
	local nowPosX = self.mapCamera:getPositionX() + distanceX
	if ((nowPosX < GameUtil:VISIBLE_WIDTH()/2) and direction == -1 ) or ((nowPosX > self.maxWidth) and direction == 1 ) then 
		return 
	end
	self.mapCamera:setPositionX(nowPosX)
end

--移动地图相机Y轴
function BattleScene:setCameraPosY(direction,y)
	local distanceY = direction * y
	local nowPosY = self.mapCamera:getPositionY() + distanceY
	if ((nowPosY < GameUtil:VISIBLE_HEIGHT()/2) and direction == -1 ) or ((nowPosY > self.maxHeight) and direction == 1 ) then 
		return 
	end
    self.mapCamera:setPositionY(nowPosY)
end


--检测墙壁 不会自由下落 不能移动
--需要在移动之前进行判断
--[[根据传进来的玩家，获取玩家的TiledMap坐标，然后判断脚下那一格是否是墙壁]]
function BattleScene:wallDetection(direction,player)
    local playerPosX = player:getPositionX()
    local playerPosY = player:getPositionY()

    local playerTiledMapPos = self:tileCoordForPosition(cc.p(playerPosX,playerPosY))
    dump(playerTiledMapPos)
    local aX,aY = 0,0

    switch(direction) : caseof
	{
	 [MoveDirectionType.left]   = function() aX,aY = -1, 0  end,
	 [MoveDirectionType.right]  = function() aX,aY =  1, 0  end,
	 [MoveDirectionType.up]     = function() aX,aY =  0,-2  end,   
	 [MoveDirectionType.down]   = function() aX,aY =  0, 1  end,

    }

    local wallPos = cc.p(playerTiledMapPos.x + aX,playerTiledMapPos.y+aY)

    local gid = self.impactLayer:getTileGIDAt(wallPos)
    
    --dump(gid)
    
    if gid == 0 then 
       return true
    else             --现在其他的都先默认是墙，以后可以扩展
       return false
    end
end

function BattleScene:targetPosIsBarrier(targetPos)

    local gid = self.impactLayer:getTileGIDAt(targetPos)
    
    --dump(gid)
    
    if gid == 0 then 
       return true
    else             --现在其他的都先默认是墙，以后可以扩展
       return false
    end
end


function BattleScene:initTouchListener( bSwallow )
	-- if bSwallow == nil then
	-- 	bSwallow = false
	-- end
	-- local function TouchBegan( touch,event )
	-- 	local location = touch:getLocation()
	-- 	return self:onTouchBegan(location.x,location.y)
	-- end
	-- local function TouchMoved( touch,event )
	-- 	local location = touch:getLocation()
	-- 	self:onTouchMoved(location.x,location.y)
	-- end
	-- local function TouchEnded( touch,event )
	-- 	local location = touch:getLocation()
	-- 	self:onTouchEnded(location.x,location.y)
	-- end
	-- local function TouchCancelled( touch,event )
	-- 	local location = touch:getLocation()
	-- 	self:onTouchCancelled(location.x,location.y)
	-- end
	-- local listener = cc.EventListenerTouchOneByOne:create()
 --    listener:registerScriptHandler(TouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
 --    listener:registerScriptHandler(TouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
 --    listener:registerScriptHandler(TouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
 --    listener:registerScriptHandler(TouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED )
 --    listener:setSwallowTouches(bSwallow)
 --    local eventDispatcher = self:getEventDispatcher()
 --    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
 --    self._listener = listener

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


function BattleScene:pressedDevourBtnListener()
    
end

function BattleScene:releasedSkillABtnListener()

end

function BattleScene:releasedSkillBBtnListener()
	
end

function BattleScene:releasedSkillCBtnListener()
	
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

function BattleScene:releasedDevourBtnListener()
    
end

function BattleScene:releasedSkillABtnListener()

end

function BattleScene:releasedSkillBBtnListener()
	
end

function BattleScene:releasedSkillCBtnListener()
	
end
--[[

    用的到的一些TiledMap地图的方法 

    设置一个地图块:     layer:setTileGID(GID, cc.p(x,y)) 
    获得一个地图块的GID layer:getTileGIDAt(cc.p(x,y))
    移除一个地图块：    layer:removeTileAt(cc.p(x,y))
    获得当前地图的每块地图的长宽  getMapSize().height   getMapSize().width
   
--]]


