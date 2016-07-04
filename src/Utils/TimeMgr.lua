--[[
@file   TimeMgr.lua
@author zln
@date   2014-08-12
@brief  时间转换类
--]]

local socket = require("socket")

local TimeMgr = class("TimeMgr")

TimeMgr.countDownTime   = nil;

function TimeMgr:ctor( )
	self.lastTime = os.time(); 
	self.srvTime = 0;
	self.loginSrvTime = 0;
	self:retain();
	
	self:setName(self.__cname)
end

function TimeMgr:getInstance( )
	if self.instance == nil then
		self.instance = TimeMgr.new();
	end
	return self.instance;
end

--启动计时器
--param:lastTime  从服务端获取的最新时间戳/秒
function TimeMgr:start(lastTime)
	if lastTime then 
		logDebug("TimeMgr:start time = "..lastTime);
	end
	self.lastTime = lastTime;
	self.srvTime = lastTime;
	self.loginSrvTime = lastTime;
	
	self.updateTime = mtSchedulerMgr():removeScheduler(self.updateTime)

	self._preTick = os.time();--cc.Time:getInterval()--os.time();

	local func = function ( )
		  self._nowTick = os.time() -- cc.Time:getInterval();--;
		  local dt = self._nowTick - self._preTick
		  self.lastTime = self.lastTime + dt;
		 -- logDebug("now clock:" .. self.lastTime)
		  self._preTick = self._nowTick
		  --g_RankDataMgr:updateTime(dt)
	end

	self.updateTime = mtSchedulerMgr():addScheduler(0,-1,func)

end


function TimeMgr:showNowTime(  )
	local timeData = self:getTimeData(self.lastTime);

end

function TimeMgr:getTimeData( sec )
	return os.date("*t", sec);
end

--获取最新时间
--return:秒数
function TimeMgr:getNowTimeForSec( )
	return self.lastTime;
end

function TimeMgr:getCurTime( )
    return os.time();
end

--毫秒级时间，用于针对技能的CD，BUFF等
function TimeMgr:getMSTime(  )
	return socket.gettime()*1000
end

--服务器下发的时间戳，服务器时间由于有心跳包，所以一直是服务器时间
function TimeMgr:getSrvTime(  )
	return self.srvTime;
end

--获取登陆时，服务器下发的时间戳
function TimeMgr:getLoginSrvTime(  )
	return self.loginSrvTime;
end

function TimeMgr:updateSrvTime( time )
	self.srvTime = time;
end

function TimeMgr:updateLoginSrvTime( )
	self.loginSrvTime = self.lastTime;
end

--获取最新时间
--[[return:{year = xx, month = xx, day = xx, yday = xx, wday = xx,
 hour = xx, min = xx, sec = xx, isdst = false}]]
function TimeMgr:getNowTime( sec )
    if self.lastTime == 0 then
    	self.lastTime = os.time();
    end
  	local dt = self.lastTime;
  	if sec then
  		dt = self.lastTime + sec
  	end
	return os.date("*t", dt);
end

---获取现在的钟表时间，不带日期 格式为  23:48:10
function TimeMgr:getNowClockTime()
	if self.lastTime == 0 then
    	self.lastTime = os.time();
    end
    local ret = os.date("%X", self.lastTime);
	return ret;
end
--返回未来与现在的时间差
--will_time:未来的某个时间点
--return:时:分:秒 xx:xx:xx , 0时间到
function TimeMgr:getDiffTime(will_time,ignoreH)
	local diffTime = will_time - self.lastTime;
	if diffTime <= 0 then
		return 0;
	end
	local hour = math.floor(diffTime / 3600);
    local min  = math.floor(diffTime % 3600 / 60);
    local sec  = math.floor(diffTime % 3600 % 60);
    if ignoreH == true then
    	return string.format("%02d:%02d",min,sec);
    else
    	return string.format("%02d:%02d:%02d",hour,min,sec);
    end
	
end

function TimeMgr:getNumDiffTime( will_time )
	local diffTime = will_time - self.lastTime;
	if diffTime < 0 then
		return 0;
	end
	local hour = math.floor(diffTime / 3600);
    local min  = math.floor(diffTime % 3600 / 60);
    local sec  = math.floor(diffTime % 3600 % 60);
    return hour,min,sec;
end

--距离下一时间点的刷新时间,0时间到
function TimeMgr:getRefreshTime( willHour,willMin,willSec,addDay )

	local curTime = self.lastTime;
	local nowData = self:getNowTime();
	if addDay and addDay > 0 then
		curTime = curTime + addDay * 86400;
		nowData = os.date("*t", curTime)
	end
	local temp = os.time({year = nowData.year,month = nowData.month,day = nowData.day,hour = willHour,min = willMin,sec = willSec}); --转换秒数
	local arriveTime = self:getDiffTime(temp);
	return arriveTime;
end


function TimeMgr:getDiffTimeNum(will_time)
	local diffTime = will_time - self.lastTime;
	if diffTime < 0 then
		return 0;
	end
	return diffTime;
end

--返回过去与现在的时间差
--will_time:未来的某个时间点
--return:时:分:秒 xx:xx:xx ,nil时间到
function TimeMgr:getDiffTime1(last_time)
	local diffTime = self.lastTime - last_time;
	
	local hour = math.floor(diffTime / 3600);
    local min  = math.floor(diffTime % 3600 / 60);
    local sec  = math.floor(diffTime % 3600 % 60);
	return string.format("%02d时%02d分%02d秒",hour,min,sec);
end

function TimeMgr:timeNum2Text(time)
	
	local hour = math.floor(time / 3600);
    local min  = math.floor(time % 3600 / 60);
    local sec  = math.floor(time % 3600 % 60);
	return string.format("%d时%d分%d秒",hour,min,sec);
end

function TimeMgr:getFormatTimeString(time)

	if time then
		local hour = math.floor(time / 3600);
    	local min  = math.floor(time % 3600 / 60);
    	local sec  = math.floor(time % 3600 % 60);
    	local timeStr = string.format("%02d:%02d:%02d",hour,min,sec);
		return timeStr;
	else
    	local timeStr = string.format("%02d:%02d:%02d",0,0,0);
		return timeStr;			
	end
	
end

--今天时间的显示
function TimeMgr:getFormatTimeStringTodayHour(time)

	if time then
		-- local hour = math.floor(time % (24*3600) / 3600);
  --   	local min  = math.floor(time % 3600 / 60);
  --   	local timeStr = string.format("%02d:%02d",hour,min);
  		local timeStrH = os.date("%H",time)
  		local timeStrM = os.date("%M",time)
		return timeStrH,timeStrM;
	else
    	-- local timeStr = os.date("%H:%M",0);
    	local timeStr = "00"
		return timeStr,timeStr;			
	end
	
end

function TimeMgr:getFormatTimeStringMinute(time)

	if time then
    	local min  = math.floor(time / 60);
    	local sec  = math.floor(time % 3600 % 60);
    	local timeStr = string.format("%02d:%02d",min,sec);
		return timeStr;
	else
    	local timeStr = string.format("%02d:%02d",0,0);
		return timeStr;			
	end
	
end

--倒计时，天 h:m:s
function TimeMgr:getFormatTimeStringDayHMS(time)

	if time then
		local day = math.floor(time / (24*3600));
		local hour = math.floor((time - (day*24*3600))/3600);
    	local min  = math.floor(time % 3600 / 60);
    	local sec  = math.floor(time % 3600 % 60);
    	local timeStr = nil;
    	if day > 0 then
    		timeStr = string.format("%d天%02d:%02d:%02d",day,hour,min,sec);
    	else
    		timeStr = string.format("%02d:%02d:%02d",hour,min,sec);
    	end
		return timeStr;
	else
    	local timeStr = string.format("%02d:%02d:%02d",0,0,0);
		return timeStr;			
	end
	
end


--秒表倒计时
--second 
function TimeMgr:countDown(curr_Second)

	local func = function ( )
		curr_Second = curr_Second - 1;
	end

	local updateTime = mtSchedulerMgr():addScheduler(1.0,-1,func)

	if curr_Second <= 0 then
	   updateTime = mtSchedulerMgr():removeScheduler(updateTime)
	end

	return curr_Second;
end

--设置倒计时时间
function TimeMgr:setCountDownTime(second)
	self.countDownTime = second;
end

function TimeMgr:getCountDownTime(  )
	if self.countDownTime == nil then
		self.countDownTime = 0;
	end
	return self.countDownTime;
end

--小时
function TimeMgr:CalDiffTime(last_time)
	local diffTime = self.lastTime - last_time;	
	local hour = math.floor(diffTime / 3600);
	return hour;
end

--星期几 0:星期天
function TimeMgr:getWeek()
	--local w = os.date("%w",os.time())
	local w = os.date("%w",self.lastTime);
	return tonumber(w);
end

function TimeMgr:getWeekExt(nowTime)
	--local w = os.date("%w",os.time())
	local w = os.date("%w",nowTime);
	return tonumber(w);
end

--当前时间
function TimeMgr:getCurrentTime()
	return self.lastTime;
end

function TimeMgr:beginTime(  )
	self._beginTime = os.clock();
	return self._beginTime
end

function TimeMgr:endTime( nBeginTime )
	if self._beginTime == nil then
		return nil;
	end
	local nEndTime = os.clock();
	if nBeginTime then
		self._beginTime = nBeginTime
	end
	local time = nEndTime - self._beginTime;
	self._beginTime = nEndTime;
	return time;
end

function TimeMgr:endTimePrint( des,endTime )
	local time = self:endTime(endTime)
	if time then
		local str = "耗时:" .. time
		if des then
			str = des .. str;
		end
		logDebug(str)
	end
end

function TimeMgr:getMonthDays( monthIndex )
	-- body
	local year1 = os.date("%Y",self.srvTime);
	local month1 = os.date("%m");
	local day1 = 0;

	if monthIndex then
		local localtime = os.time({year=year1,month=monthIndex+1,day=day1});
		local days = os.date("%d",localtime);
		return days;
	else
		local localtime = os.time({year=year1,month=month1+1,day=day1});
		local days = os.date("%d",localtime);
		return days;
	end
	
end

function TimeMgr:getDateToString( paramTime )
	-- body
	--local strDate = os.date("%Y-%m-%d %H:%M:%S",paramTime);
	local strDate = os.date("%m月%d日",paramTime);
	return strDate;
	
end

function TimeMgr:getNowDay(paramTime)
	local strDate = os.date("%d",paramTime);
	return strDate;
end

function TimeMgr:getDateToStringEx( paramTime )
	-- body
	--local strDate = os.date("%Y-%m-%d %H:%M:%S",paramTime);
	local strDate = os.date("%m月%d日%H时",paramTime);
	return strDate;
	
end

function TimeMgr:getDateToStringEx2( paramTime )
	-- body
	--local strDate = os.date("%Y-%m-%d %H:%M:%S",paramTime);
	local todayTime = paramTime-24*3600;
	if todayTime <= 0 then
		todayTime = os.time();
	end
	local strDate = os.date("%m月%d日",todayTime);
	return strDate;
	
end

function TimeMgr:getDiffTimeBefore(_time)
    local dt = self:getCurrentTime() - _time;
    local dtUnit = nil;
    dt = dt < 0 and 0 or dt;
    if dt / (24 * 60 * 60) > 1 then
        dt = dt / (24 * 60 * 60);
        dtUnit = "天前"; 
    elseif dt / (60 * 60) > 1 then
        dt = dt / (60 * 60);
        dtUnit = "小时前";
    else
        dt = dt / 60;
        dtUnit = "分钟前";
    end
    dt = math.floor(dt);
    dt = dt == 0 and 1 or dt;
    return dt..dtUnit
end

function TimeMgr:getTheOpenDayOfCanival( startTime )
	-- body
	-- local serverNowTimeEx = self.lastTime - 5*3600
	local serverNowTimeEx = self.lastTime
	local diffTime = serverNowTimeEx - startTime
	if diffTime <= 0 then
		return 0;
	else
		local theOpenDay = math.floor(diffTime/(24*3600))
		if diffTime % (24*3600) > 0 then
			theOpenDay = theOpenDay + 1
		end

		return theOpenDay
	end
end

function TimeMgr:string2Timestamp( strTime )
	-- body
	local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
	-- local timeToConvert = "2011-01-01 01:30:33"
	local runyear, runmonth, runday, runhour, runminute, runseconds = strTime:match(pattern)

	local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})

	return convertedTimestamp
end

return TimeMgr