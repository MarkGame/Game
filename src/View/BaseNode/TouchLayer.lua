--[[
@file   TouchLayer.lua
@author zone
@date   2014-08-20
@brief  具有触摸属性的节点
		注意:如果子类重新注册了exit事件,则需显示调用self:removeTouchListener()
--]]


local TouchLayer = class("TouchLayer", function (  )
	return cc.Layer:create();
end)

--bSwallow :是否吞噬触摸点
function TouchLayer:ctor( bSwallow )

	-- g_Worker:pushDelayQueue(Task.new(function ( )
	-- 	if self.initTouchListener ~= nil then
	-- 		self:initTouchListener(bSwallow);
	-- 	end
	-- end),0)

	self.eventListeners = {};	
	self:registerScriptHandler(function ( event )
		if event == "enter" then
			 self:onEnter();
		elseif event == "exit" then
			self:removeTouchListener();
			self:onExit();
		end
	end);
end

--bSwallow:是否吞并触摸节点(默认false),设为true后,将不会派发触摸点到子节点
function TouchLayer:initTouchListener( bSwallow )
	if bSwallow == nil then
		bSwallow = false;
	end
	local function TouchBegan( touch,event )
		local location = touch:getLocation();
		return self:onTouchBegan(location.x,location.y);
	end
	local function TouchMoved( touch,event )
		local location = touch:getLocation();
		self:onTouchMoved(location.x,location.y);
	end
	local function TouchEnded( touch,event )
		local location = touch:getLocation();
		self:onTouchEnded(location.x,location.y);
	end
	local function TouchCancelled( touch,event )
		local location = touch:getLocation();
		self:onTouchCancelled(location.x,location.y);
	end
	local listener = cc.EventListenerTouchOneByOne:create();
    listener:registerScriptHandler(TouchBegan,cc.Handler.EVENT_TOUCH_BEGAN );
    listener:registerScriptHandler(TouchMoved,cc.Handler.EVENT_TOUCH_MOVED );
    listener:registerScriptHandler(TouchEnded,cc.Handler.EVENT_TOUCH_ENDED );
    listener:registerScriptHandler(TouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED );
    listener:setSwallowTouches(bSwallow);
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
    self._listener = listener;

	-- self:registerScriptHandler(function ( event )
	-- 	if event == "exit" then
	-- 		self:removeTouchListener();
	-- 		self:onExit();
	-- 	end
	-- end);
end
function TouchLayer:removeTouchListener(  )
	if self._listener then 
		local eventDispatcher = self:getEventDispatcher();
		eventDispatcher:removeEventListener(self._listener);
		self._listener = nil;
    end
end


function TouchLayer:onEnter()
	-- body
end

function TouchLayer:onTouchBegan( x,y )
	return true;
end

function TouchLayer:onTouchMoved( x,y )
	-- body
end

function TouchLayer:onTouchEnded( x,y )
	-- body
end
function TouchLayer:onTouchCancelled( x,y )
	-- body
end
function TouchLayer:onExit(  )
	if self.eventListeners == nil then
		return ;
	end
	for i,v in ipairs(self.eventListeners) do
		g_EventDispatch:removeEvent(v);
	end
end

function TouchLayer:registerEvent( event,callBack,groupID,priority )
	self.eventListeners = self.eventListeners or {};
	self.eventListeners[#self.eventListeners + 1] = g_EventDispatch:registerEvent(event,callBack,groupID,priority);
end

function TouchLayer:dispatchEvent(event,data)
	g_EventDispatch:dispatchEvent(event,data);
end

return TouchLayer