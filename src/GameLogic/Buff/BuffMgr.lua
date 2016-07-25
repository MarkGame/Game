--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- buff管理器

--[[
    
]]

require "BuffMap"

local BuffMgr = class("BuffMgr")


function BuffMgr:getInstance(  )
    if self.instance == nil then
        self.instance = BuffMgr.new()
    end
    return self.instance
end

function BuffMgr:ctor()
   --存放全部BUFF的数组
   self.buffLogicList = {}
   self:registerAllBuff()

end

--创建BUFF
function BuffMgr:createBuff(buffID)

	--根据 BUFF的类型 去创建 
    local data = {}
    data.buffID = buffID
    local buffLogic = self:getBuffLogicByBuffID(data.buffID)
    
    return buffLogic(data)

end

--移除BUFF
function BuffMgr:removeBuff( buffID )
   
end


--注册全部的BUFF
--目前打算，在加载进入地图的时候，去注册
function BuffMgr:registerAllBuff()
    for k,v in pairs(BuffMap) do
        self:registerBuffCreator({buffID = k, funcLogic = v.buffLogic})
    end
end

--将注册的BUFF 存放在 self.buffLogicList 中
function BuffMgr:registerBuffCreator(data)

    self.buffLogicList = self.buffLogicList or {}
    local funcLogic = self.buffLogicList[data.buffID]
    --检查一下当前BUFF是否存在
    if nil ~= funcLogic then
        print("registerBuffCreator() Failed. BuffID: " .. data.buffID)
        return
    end
    --将BUFF逻辑存放在数组里
    self.buffLogicList[data.buffID] = data.funcLogic

end

--获得指定BUFF的 logic   

function BuffMgr:getBuffLogicByBuffID( buffID )
    local buffLogic = self.buffLogicList[buffID]
    if buffLogic == nil then return print("buffID 不存在") end
    return buffLogic
end

return BuffMgr