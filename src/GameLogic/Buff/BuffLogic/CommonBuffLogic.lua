--
-- Author: HLZ
-- Date: 2016-04-27 20:47:31
-- BUFF的通用逻辑
-- 

local CommonBuffLogic = class("CommonBuffLogic")

function CommonBuffLogic:ctor()
  
end

function CommonBuffLogic:init(data)

    self.buffID = data.buffID
    
    --当前是否为激活状态，一个BUFF只会激活一次， 如果已经激活则无法再执行
    self.isActivation = false 
    
    --携带BUFF的对象
    self.monster = nil 

    self:initBuffData()
end

--初始化BUFF信息
function CommonBuffLogic:initBuffData()
    	  --获得表格里面的BUFF信息
	local buffInfo = g_Config:getData(GameConfig.addConfig["Buff"],"ID",self.buffID)[1]
    
    self.buffData = mtBuffBaseInfo().new(buffInfo)
    
    self:setBuffInitTime()

end

function CommonBuffLogic:getBuffData( )
    return self.buffData
end

--设置BUFF的结束时间
function CommonBuffLogic:setBuffInitTime( )
    self.buffData:initBuffEndTime()
end

--monster是指 buff作用的对象 直接在该monster上面使用效果
function CommonBuffLogic:launch(monster)
  
end

--移除施加在BUFF身上的BUFF，并消除自身
function CommonBuffLogic:removeBuff( )
    
end
--是否激活
--[[
    现在需要讨论这里的 时间需要怎么去判断
    1、如果 准确到秒，只需要把持续时间 和 当前时间 结合，算出结束时间，然后每秒判断一次
    2、如果 准确到秒以内，则需要用计时器去判断，当BUFF激活的时候，开始自身的一个计时器，达到那个时间的时候，则抵销BUFF
    
    第二种 延时很容易出问题，正常的做法还是 给BUFF结束时间
]]
function CommonBuffLogic:isDurationTime( )
    --获得毫秒级的时间
	local time = mtTimeMgr():getMSTime()
    local endTime = self.buffData:getBuffEndTime()
    if endTime ~= 0 and time <= endTime then  --还在BUFF有效时间内
       return true
    else 
       --BUFF时间到了 在调用该方法地方去removeBuff 并移除BUFF队列
       return false
    end


end



return CommonBuffLogic