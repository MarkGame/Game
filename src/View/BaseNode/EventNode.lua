--
-- Author: HLZ
-- Date: 2015-12-29 12:30:49
-- 节点类的封装

EventNode = class("EventNode",function ()
	return cc.Node:create()
end)

EventNode.__index = EventNode

--[[
    继承于 EventNode的类，需要在ctor() onEnter() onExit() 加上 .super.ctor(self)类似的方法 
--]]

function EventNode:ctor()
	
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

end

function EventNode:dispatchEvent(event,data)
	g_EventDispatch:dispatchEvent(event,data)
end

function EventNode:registerEvent( event,callBack,groupID,priority )
	--将事件加入数组，方便在退出的时候将侦听事件给移除掉
	self.eventListeners = self.eventListeners or {}
	self.eventListeners[#self.eventListeners + 1] = g_EventDispatch:registerEvent(event,callBack,groupID,priority)
	return self.eventListeners[#self.eventListeners + 1]
end

function EventNode:onExit( )
	if self.eventListeners == nil then
		return 
	end
	--统一对事件数组里面的时间进行释放
	for i,v in ipairs(self.eventListeners) do
		g_EventDispatch:removeEvent(v)
	end	
end

function EventNode:onEnter( )
	
end

function EventNode:onHide(  )
	
end