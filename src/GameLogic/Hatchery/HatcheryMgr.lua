--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 孵化场管理器

--[[
    
]]

local HatcheryMgr = class("HatcheryMgr")
HatcheryMgr.__index = HatcheryMgr

function HatcheryMgr:getInstance(  )
    if self.instance == nil then
        self.instance = HatcheryMgr.new()
    end
    return self.instance
end

function HatcheryMgr:ctor()

end

function HatcheryMgr:createHatchery(data)
	local skillLogic = mtCommonHatcheryLogic().new(data)
    
    local hatcheryView = mtHatcheryView().new(skillLogic)
    
    return hatcheryView
end

return HatcheryMgr