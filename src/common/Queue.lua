--[[
@file   Queue.lua
@author zln
@date   2014-08-07
@brief  队列的简单实现
--]]

local Queue = class("Queue");

 

function Queue:ctor( )
	self._queue = {};
	self._first = 0;
	self._last = 0;
	self._size = 0;
end

function Queue:clean( )
 	self._queue = {};
 	self._first = 0;
 	self._last = 0;
 	self._size = 0;
 end 

function Queue:push(value)
	if value == nil then
		return ;
	end
	if self._queue[self._last] == nil then
		self._queue[self._last] = value;
	else
		self._last = self._last + 1;
		self._queue[self._last] = value;
	end
	self._size = self._size + 1;
end

function Queue:pushFront(value)
	if self._queue[self._first] == nil then
		self._queue[self._first] = value;
	else
		self._first = self._first - 1;
		self._queue[self._first] = value;
	end
	self._size = self._size + 1;
end

 function Queue:empty( )
 	if self._queue[self._last] == nil and self._queue[self._first] == nil then
 		return true;
 	else
 		return false;
 	end
 end

function Queue:size( )
	return self._size;
end

function Queue:front( )
	return self._queue[self._first];
end

function Queue:back( )
	return self._queue[self._last];
end

function Queue:atIndex( index )
	return self._queue[self._first + index - 1];
end


function Queue:pop ()

	if self._queue[self._first] == nil then
		return nil;
	else
		local value = self._queue[self._first];
		self._queue[self._first] = nil;
		local temp = self._first + 1;
		if self._queue[temp] then
			self._first = temp;
		end
		self._size = self._size - 1;
   	    return value;
   	end
end

function Queue:popBack( )
	if self._queue[self._last] == nil then
		return nil;
	else
		local value = self._queue[self._last];
		self._queue[self._last] = nil;
		temp = self._last - 1;
		if self._queue[temp] then
			self._last = temp;
		end
		self._size = self._size - 1;
   	    return value;
   	end
end

return Queue