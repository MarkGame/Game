--
-- Author: HLZ
-- Date: 2016-01-06 14:02:56
-- 1V1地图场景


--[[
     
--]]

require("View.Player.PlayerView")

BattleSceneView = class("BattleSceneView",BattleScene)

function BattleSceneView:ctor()
	BattleSceneView.super.ctor(self)
end

function BattleSceneView:initScene()
	if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(self)
    else
        cc.Director:getInstance():runWithScene(self)
    end
    self:initEvent()
    self:initTileMap()

end

function BattleSceneView:initEvent()
    -- self:registerEvent(TEST_EVENT_RETURN,function(event)
    --     print("TEST_EVENT_RETURN")
    -- end)
end

function BattleSceneView:initTileMap()


    --定义战斗信息管理 并初始化
    mtBattleMgr():initData()

    --加载背景图片
    self.guiBackgroundNode = createGUINode(res.RES_BACKGROUND_ORIGINAL)
    self.guiBackgroundNode:setName("self.guiNode")
    --背景层是不需要动的
    self:addChild(self.guiBackgroundNode)
    --self.guiNode:setVisible(false)
    --dump(cc.Camera:getDefaultCamera():getPosition())


    --加载地图
    self.map = self:createTMXTM(ORIGINAL_SCENCE_TMX)
    self.map:setName("self.map")
    self:addChild(self.map,5)
    self.map:setAnchorPoint(cc.p(0,0))    
      
    self.impactLayer = self:getLayer(TiledMapLayer.barrier)
    --self.backGroundLayer = self:getLayer(TiledMapLayer.background)
    self.impactLayer:setVisible(false)
    --self.impactLayer:setOpacity(255*0.8)
    local data = {}
    data.parent = self
    self.player =  mtPlayerMgr():createPlayerView(data)
    self.map:addChild(self.player,10) 

    self:setPlayer(self.player)

    --self.player:openOrColseGravity(true)
 
    --主角初始位置
    self.initPlayerPos = self:positionForTileCoord(cc.p(2,11))
    --self.player:moveToward(cc.p(18,7))

    self.player:setPosition(self.initPlayerPos)

    mtBattleMgr():setMyMonster(self.player)

    self:initHatchery()
    
    --self:refreshMonster()
    
    --添加摄像机 （背景相机 和 地图相机）
    self.backgroundCamera = self:setBackgroundCamera(self.guiBackgroundNode)
    self.mapCamera = self:setMapCamera(self.map,self.player)
    
 
    --开启键盘控制（win32版本使用）
    if g_game:getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then 
       self:initKeyBoardListener()
    end

    -- local info = g_Config:getData2(GameConfig.addConfig["SkillRange"],{{key = "SkillRangeType",value = 1},{key = "SkillRange",value = 2}})
    -- dump(info)

    --开启触摸事件
    --self.player:moveToward(cc.p(25,5)) 
end

--初始化 孵化场
function BattleSceneView:initHatchery( )
    --这里去读表吧。。
    local initPosList = {
    {cc.p(22,7),cc.p(20,6)},
    {cc.p(6,7),cc.p(7,6)},
    {cc.p(6,18),cc.p(7,17)},
    {cc.p(22,18),cc.p(20,17)}
    }
    for i =1 ,4 do 
        local data = {}
        data.parent = self
        data.initPos = initPosList[i][1]

        local hatchery = mtHatcheryMgr():createHatchery(data)
        self.map:addChild(hatchery,10) 
     
        --主角初始位置
        local hatcheryPos = self:positionForTileCoord(initPosList[i][2])
        --self.player:moveToward(cc.p(18,7))

        hatchery:setPosition(hatcheryPos)
    end


end

function BattleSceneView:getMap( )
    return self.map
end

function BattleSceneView:onEnter()
	BattleSceneView.super.onEnter(self)
    print("BattleSceneView onEnter")
    --self:initScene()
end

function BattleSceneView:onExit()
	BattleSceneView.super.onExit(self)
    print("BattleSceneView onExit")
end

function BattleSceneView.open()
	local view = BattleSceneView.new()
	view:initScene()
	--这里以后肯定要进行特殊处理
end

