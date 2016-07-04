--
-- Author: HLZ
-- Date: 2016-06-30 17:14:52
-- 游戏统一的调度器
--[[

     大概的原理就是，在游戏中只创建一个调度器，减少创建多个调度器没必要的开销
     使用的方法 ，每帧都去调度一次，根据一些参数来判断是否每秒，每两秒等执行的一些方法
     每次遍历一次所有的scheduler数组
     通过控制scheduler里面的成员来 添加删除各个功能的调度

]]

local SchedulerMgr = class("SchedulerMgr")


function SchedulerMgr:ctor( )
    
    --存放各个需要调度的方法
    self.schedulerList = {}
    
    --每个scheduler的key 删除之后，这个KEY值就不会再用了。
    self.schedulerID = 0
    --初始化执行一次
    self:stopUpdateGame()

    self.lastFrameTime = mtTimeMgr():getMSTime()
    --每帧去执行一次
    self.updateHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self,self.updateGame),0,false)

end

function SchedulerMgr:getInstance( )
	if self.instance == nil then
		self.instance = SchedulerMgr.new()
	end
	return self.instance
end

--每帧调度
function SchedulerMgr:updateGame( )

    --获取上一帧开始 到这一帧 开始 的间隔时间
    local eachFrameTime = mtTimeMgr():getMSTime() - self.lastFrameTime
    self.lastFrameTime =  mtTimeMgr():getMSTime()

    --获得 数组里面最大的key值
	local totalCount = table.maxn(self.schedulerList)
    
    --当数组内没有需要调度的时候 直接返回 
    if totalCount == 0 then
       return 
    end

    for key,scheduler in pairs(self.schedulerList) do
        if scheduler then 
           scheduler.m_pastTime = scheduler.m_pastTime + eachFrameTime
           if scheduler.m_interval == 0 or scheduler.m_pastTime >= scheduler.m_interval then
              --回调一次该方法
              scheduler.m_callBack(key)
              scheduler.m_pastTime = scheduler.m_pastTime - scheduler.m_interval
              scheduler.m_curTimes = scheduler.m_curTimes + 1
              if scheduler.m_times >= 0 and scheduler.m_curTimes >= scheduler.m_times then 
                 self:removeScheduler(key)
              end
           end
        end
    end

end

--添加需要调度的方法到调度数组内
--传入需要调度的方法func、 间隔时间interval、调用次数times 
--间隔时间interval 为 0 时 ，为每帧都调用
--调用次数times 为-1时，为无限次数 为整型
function SchedulerMgr:addScheduler(interval,times,callBack)
    --在队列里面累加
	self.schedulerID = self.schedulerID + 1 

    self.schedulerList[self.schedulerID] = 
    {
       m_interval = interval ,
       m_times = times ,
       m_callBack = callBack ,
       m_pastTime = 0 ,
       m_curTimes = 0   }

    return self.schedulerID

end

--移除调度方法从调度数组中
function SchedulerMgr:removeScheduler( id )
	if id ~= nil and self.schedulerList[id] ~= nil then 
       self.schedulerList[id] = nil
    end
    return nil
end

--一般并不需要执行该方法，使用时慎用
function SchedulerMgr:stopUpdateGame( )
	if self.updateHandler ~= nil  then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateHandler);
        self.updateHandler = nil 
    end
end

return SchedulerMgr


