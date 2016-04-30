--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 孵化场管理器

--[[
    
]]

local BuffMgr = class("BuffMgr")
BuffMgr.__index = BuffMgr

function BuffMgr:getInstance(  )
    if self.instance == nil then
        self.instance = BuffMgr.new()
    end
    return self.instance
end

function BuffMgr:ctor()

end

function BuffMgr:createBuff(data)
	local buffLogic = mtCommonBuffLogic().new(data)
    
    --local hatcheryView = mtHatcheryView().new(skillLogic)
    
    return buffLogic
end

return BuffMgr