--
-- Author: zone
-- Date: 2014-10-07 19:11:32
-- 任务处理器


Worker = class("Worker")


function Worker:ctor()
	
end

function Worker:getInstance( )
	if self.instance == nil then
		self.instance = Worker.new();
	end
	return self.instance;
end

function Worker:pushDelayQueue( task,delay )
	local timer = nil;
	if delay == nil then
		delay = 0;
	end
	timer = g_scheduler:scheduleScriptFunc(function ( dt )
		if timer then
			g_scheduler:unscheduleScriptEntry(timer);
		end
		if task ~= nil then
			if type(task) == "function" then
				task();
			end
		end
	end, delay, false);
end
