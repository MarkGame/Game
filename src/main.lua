
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

--在这个里面加，通过数组来逐个require
LuaFileList = {
  "Utils.Config.AllRequires",
  "GameLogic.Game",
  "Framework.ResManager.ResManager",
  --"Utils.EventDispatch",
  "Utils.Functions",

  --"Utils.Log",
  --"common.Queue",
  "Utils.EventID",
  "Utils.GameUtil",
  "Utils.AnimationCacheFunc",
  "common.GameDefine",
  "common.ConfigManagerToLua",
  --"Utils.TimeMgr",
  "Utils.Worker",
  
  --"GameLogic.Data.clientDBGame"
}



--[[
    这里需要遵循一个规则 
    调用的方法，必须在当前方法的上面
    例如：
    main()需要调用startGameWithSplash()，则startGameWithSplash()方法必须写在main()上面
    依次同理
]]

-- 启动游戏
local function startGame()
   --初始化 一个游戏入口管理类
   print("startGame")
   g_game:start()
end

-- 启动闪屏界面
local function startGameWithSplash()

    local SearchPathConfig = require("Utils.SearchPathConfig")
    SearchPathConfig.init();
 
    for i,v in ipairs(LuaFileList) do
        require(v)
    end

    g_game            = Game:getInstance()
    g_ResManager      = ResManager:getInstance()
    --g_EventDispatch   = EventDispatch:getInstance()
    --g_scheduler       = cc.Director:getInstance():getScheduler()
    g_Config          = ConfigManagerToLua:getInstance()
    --g_TimeMgr         = TimeMgr:getInstance()
    g_Worker          = Worker:getInstance()  

    --加载资源
    AnimationCacheFunc.addSpriteFramesWithFile("publish/action/monster64.plist")

    startGame()
end

--加载一些全局管理器
local function loadGlobalMgr(scene)
    --scene:addChild(g_EventDispatch)

end



local function main()
    --require("app.MyApp"):create():run()


    --在main函数里面，可以初始化一些单例
    --g_EventDispatch = EventDispatch:getInstance()

    --[[
    collectgarbage (opt [, arg])
　　功能：是垃圾收集器的通用接口，用于操作垃圾收集器
    ]]
    collectgarbage("collect");
    -- avoid memory leak
    collectgarbage("setpause", 100);
    collectgarbage("setstepmul", 5000);
    
    --开始游戏
    --Game:getInstance():start()
    startGameWithSplash()
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
