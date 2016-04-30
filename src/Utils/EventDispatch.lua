--
-- Author: Your Name
-- Date: 2015-12-29 12:37:11
-- 事件派发类 
-- 是一个单例 用于发送 接收事件 （不同类互相联系的桥梁）


EventDispatch = class("EventDispatch",function()
	return cc.Node:create()
end)

function EventDispatch:ctor()
	--默认事件
	self.dispatcher = self:getEventDispatcher()
	self.groupSender = {}
	
	print("EventDispatch")
	
end

function EventDispatch:getInstance()
	if self.instance == nil then 
	   self.instance = EventDispatch.new()
	   --在整个游戏中，都要存在，不能被释放
	   self.instance:retain()
	end
	return self.instance
end

--添加到数组，并获得该事件
function EventDispatch:getEventDispatcherByIndx(index)
	local dispatcher = self.groupSender[index]
	if dispatcher == nil then 
	   dispatcher = cc.EventDispatcher:new()
	   dispatcher:retain()

	   dispatcher:setEnabled(true)
	   self.groupSender[index] = dispatcher
	end

	return dispatcher
end

function EventDispatch:removeEventDispatcherByIndx(index)
	local dispatcher = self.groupSender[index]
	if dispatcher ~= nil then 
		dispatcher:release()

		self.groupSender[index] = nil
	end
end

--[[
    三个主要事件功能 ：
       注册事件
       移除事件
       派发事件
--]]


--注册事件
--[[    
    param:event:事件名(字符串)
    func:回调函数 func(event) end
    groupID:分组ID
    return:listern(外部用来移除)
--]]

function EventDispatch:registerEvent(event, func, groupID, priority)
    local dispatcher = nil 
    if groupID then 
       dispatcher = self.groupSender[groupID]
    else
       dispatcher = self.dispatcher
    end
    if priority == nil then
		priority = 1;
	end

    local listener = cc.EventListenerCustom:create(event,func)
    dispatcher:addEventListenerWithFixedPriority(listener, priority)

    return listener
end

function EventDispatch:removeEvent(listener, groupID)
    local dispatcher = nil
	if groupID then
		dispatcher = self:getDispatcherByID(groupID)
	else
		dispatcher = self.dispatcher
	end 
	if listener then
		dispatcher:removeEventListener(listener)
	end
end

function EventDispatch:dispatchEvent(event,data,groupID)
    local dispatcher = nil
	if groupID then
		dispatcher = self:getDispatcherByID(groupID)
	else
		dispatcher = self.dispatcher
	end 
	local event = cc.EventCustom:new(event)
    event.data = data
    dispatcher:dispatchEvent(event)
end






