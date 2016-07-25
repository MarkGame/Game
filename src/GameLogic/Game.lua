--
-- Author: HLZ
-- Date: 2015-12-29 14:44:00
-- 游戏场景管理类

--[[
    游戏场景的管理类
    负责一开始的游戏加载场景
    游戏的主城场景
    游戏的各类分支场景的管理
]]


local LoadingSceneView = require("View.SceneView.LoadingSceneView")
local StartSceneView = require("View.SceneView.StartSceneView")
local BattleSceneView = require("View.SceneView.BattleSceneView")

local LoginSceneView = require("View.LoginView.LoginSceneView")

Game = class("Game")
Game.__index = Game

--初始化
function Game:ctor()

end

--生成单例
function Game:getInstance()
	if self.instance == nil then 
	   self.instance = Game.new()
	end
    return self.instance
end

function Game:start()
	--可以进行一些单例的初始化
	--推送协议的初始化（针对以后的服务器使用）
    
    --初始化随机种子
    math.randomseed(os.time())

    print("enterLoadingScene")
    
    --开始唯一调度器 并开始 每帧调用
    mtSchedulerMgr()

    self:enterLoadingScene()
    --LoginSceneView.open()
end

function Game:getTargetPlatform()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    -- if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or
    --     (cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
    --     (cc.PLATFORM_OS_MAC == targetPlatform) then
    --     cclog("result is ")
    --     --require('debugger')()

    -- end
    return targetPlatform
end

function Game:enterLoadingScene()
    LoadingSceneView.open()
end

function Game:enterStartScene()
    StartSceneView.open()
end

function Game:enterOriginalScene()
    BattleSceneView.open()
end

function Game:enterBattleScene()

end
