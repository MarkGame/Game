--
-- Author: HLZ
-- Date: 2016-04-28 11:52:31
-- 世界树信息管理器

--[[
    刷新世界树果实
    刷新饱食度道具
    刷新进化值道具
]]

local YggdrasilMgr = class("YggdrasilMgr")


function YggdrasilMgr:getInstance(  )
    if self.instance == nil then
        self.instance = YggdrasilMgr.new()
    end
    return self.instance
end

function YggdrasilMgr:ctor()

end