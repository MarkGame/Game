--
-- Author: HLZ
-- Date: 2016-01-06 16:47:59
-- 封装一个事件场景

EventScene = class("EventScene", function (  )
	return cc.Scene:create()
end)
EventScene.__index = EventScene

--[[
    继承于 EventScene的类，需要在ctor() onEnter() onExit() 加上 .super.ctor(self)类似的方法 
--]]

function EventScene:ctor()
	
	--当前场景监听的事件数组
	self.eventListeners = {}
   
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

function EventScene:dispatchEvent(event,data)
	g_EventDispatch:dispatchEvent(event,data)
end

function EventScene:registerEvent( event,callBack,groupID,priority )
	--将事件加入数组，方便在退出的时候将侦听事件给移除掉
	self.eventListeners = self.eventListeners or {}
	self.eventListeners[#self.eventListeners + 1] = g_EventDispatch:registerEvent(event,callBack,groupID,priority)
	return self.eventListeners[#self.eventListeners + 1]
end

function EventScene:onExit( )
	if self.eventListeners == nil then
		return 
	end
	--统一对事件数组里面的时间进行释放
	for i,v in ipairs(self.eventListeners) do
		g_EventDispatch:removeEvent(v)
	end
	--self:_removeTimer();
	
end

function EventScene:onEnter( )
	
end

function EventScene:onHide(  )
	
end

-- function EventScene:createTMXTM(file)
-- 	return cc.TMXTiledMap:create(file)
-- end



-- --开启时间计时？
-- function EventNode:_startTimer( func,dt )
-- 	self:_removeTimer();
-- 	if dt == nil then
-- 		dt = 0;
-- 	end
-- 	self._timerCount = g_scheduler:scheduleScriptFunc(function (  )
-- 		if func then
-- 			func();
-- 		end
-- 	end, dt, false)
-- end

-- --移除时间计时
-- function EventNode:_removeTimer(  )
-- 	if self._timerCount then
-- 		g_scheduler:unscheduleScriptEntry(self._timerCount)
-- 		self._timerCount = nil;
-- 	end
-- end


