--
-- Author: HLZ
-- Date: 2016-06-16 16:52:31
-- BUFF的基本结构体

local BuffBaseInfo = class("BuffBaseInfo")

function BuffBaseInfo:ctor( data )
    
    --表格的基本属性
    self.id = data.ID
    self.name = data.Name
    self.type = data.Type 
    self.time = data.Time
    self.desc = data.Desc
    self.value = data.Value 

    self.endTime = 0

end

function BuffBaseInfo:getBuffID( )
	return self.id
end

function BuffBaseInfo:getBuffName( )
	return self.name
end

function BuffBaseInfo:getBuffType( )
	return self.type
end

function BuffBaseInfo:getBuffDesc( )
	return self.desc
end

function BuffBaseInfo:getBuffValue( )
	return self.value
end

function BuffBaseInfo:getBuffTime( )
	return self.time
end

function BuffBaseInfo:getBuffEndTime( )
	return self.endTime
end

function BuffBaseInfo:initBuffEndTime(  )
	local nowTime = mtTimeMgr():getMSTime()
	self.endTime = nowTime + self.time
end

return BuffBaseInfo