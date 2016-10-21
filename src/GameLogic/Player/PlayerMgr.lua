--
-- Author: HLZ
-- Date: 2016-01-07 20:20:33
-- 玩家信息管理类

local PlayerMgr = class("PlayerMgr")
PlayerMgr.__index = PlayerMgr

function PlayerMgr:getInstance(  )
    if self.instance == nil then
        self.instance = PlayerMgr.new()
    end
    return self.instance
end

function PlayerMgr:ctor()

end

--创建玩家主兽
function PlayerMgr:createPlayerView(data)

	local playerLogic = mtPlayerLogic().new(data)

	local playerView = mtPlayerView().new(playerLogic)
    local birthTime = mtTimeMgr():getCurTime()
    playerLogic:setMonsterBirthTime(birthTime)
    
    --玩家不能添加到该数组内
    --mtBattleMgr():addMonsterToList(playerView)
    
    return playerView
end

return PlayerMgr