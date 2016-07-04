--
-- Author: HLZ
-- Date: 2016-01-06 14:02:56
-- 1V1地图场景


--[[
     
--]]

BattleSceneView = class("BattleSceneView",BattleScene)

function BattleSceneView:ctor()
	BattleSceneView.super.ctor(self)

    self:setName("BattleSceneView")
end

function BattleSceneView:initScene()
	if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(self)
    else
        cc.Director:getInstance():runWithScene(self)
    end
    
    self:initTileMap()

end



function BattleSceneView:initTileMap()

    local data = {}
    data.scene = self
    --定义战斗信息管理 并初始化
    mtBattleMgr():initData(data)
    --当前是否在使用技能
    self.isUsingSkill = false

    --加载背景图片
    self.guiBackgroundNode = createGUINode(res.RES_BACKGROUND_ORIGINAL)
    self.guiBackgroundNode:setName("self.guiBackgroundNode")
    --背景层是不需要动的
    self:addChild(self.guiBackgroundNode)
    --self.guiNode:setVisible(false)
    --dump(cc.Camera:getDefaultCamera():getPosition())

    self.guiBattleMainNode = createGUINode(res.RES_BATTLE_MAIN_UI)
    self.guiBattleMainNode:setName("self.guiBattleMainNode")
    self:addChild(self.guiBattleMainNode,15)
  
    --加载地图
    self.map = self:createTMXTM(ORIGINAL_SCENCE_64_TMX)
    self.map:setName("self.map")
    self:addChild(self.map,5)
    self.map:setAnchorPoint(cc.p(0,0))    
      
    self.impactLayer = self:getLayer(TiledMapLayer.barrier)
    --self.backGroundLayer = self:getLayer(TiledMapLayer.background)
    self.impactLayer:setVisible(false)
    --self.impactLayer:setOpacity(255*0.8)
    local data = {}
    self.player =  mtPlayerMgr():createPlayerView(data)
    self.map:addChild(self.player,10) 
    
    --
    --self:setPlayer(self.player)

    --self.player:openOrColseGravity(true)
 
    --主角初始位置
    self.initPlayerPos = self:positionForTileCoord(cc.p(14,8))
    --self.player:moveToward(cc.p(18,7))

    self.player:setPosition(self.initPlayerPos)

    

    mtBattleMgr():setMyMonster(self.player)
    


    -- print("---convertToNodeSpace player:getPosition()--")
    -- dump(self.map:convertToNodeSpace(cc.p(self.player:getPosition())))
    -- print("---player:getPosition()--")
    -- dump(cc.p(self.player:getPosition()))

   
    --self:refreshMonster()
    
    --添加摄像机 （背景相机 和 地图相机）
    --2016年5月3日17:27:40的我：怪兽的偏移可能和摄像机的相关设置有关
    --2016年5月3日23:53:40的我：经测试 和 摄像机有关
    --2016年5月5日01:05:44的我: 问题解决了，传进去的不能是self.map 而是self 就好了
    --2016年5月5日23:14:20的我：然而 并没有解决问题，加在上面 根本就看不到了
    --2016年5月6日01:38:37的我：沉重的表示，放弃相机的使用
    --self.backgroundCamera = self:setBackgroundCamera(self.guiBackgroundNode)
    --self.mapCamera = self:setMapCamera(self,self.player)
    
 
    --开启键盘控制（win32版本使用）
    if g_game:getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then 
       self:initKeyBoardListener()
    end

    -- local info = g_Config:getData2(GameConfig.addConfig["SkillRange"],{{key = "SkillRangeType",value = 1},{key = "SkillRange",value = 2}})
    -- dump(info)

    --开启触摸事件
    --self.player:moveToward(cc.p(25,5))

    --初始化 孵化场
    self:initHatchery()
    --初始化 面板UI
    self:initGUI() 
    --初始化事件
    self:initEvent()
    
    self:initMapPos()
end

function BattleSceneView:initGUI( )
    self.panelSkill = self.guiBattleMainNode:getChildByName("Panel_Skill")
    self.panelPlayerInfo = self.guiBattleMainNode:getChildByName("Panel_PlayerInfo")
    
    self.progressBarSatiation = self.panelPlayerInfo:getChildByName("Image_Satiation"):getChildByName("ProgressBar_Satiation")
    self.labelSatiation = self.panelPlayerInfo:getChildByName("Image_Satiation"):getChildByName("Label_Satiation")

    self.progressBarEvolution = self.panelPlayerInfo:getChildByName("Image_Evolution"):getChildByName("ProgressBar_Evolution")
    self.labelEvolution = self.panelPlayerInfo:getChildByName("Image_Evolution"):getChildByName("Label_Evolution")

    self.buttonSkillDevour = self.panelSkill:getChildByName("Button_Skill_Devour")
    self.buttonSkillDevour:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began and self.isUsingSkill == false then  --按下
           self.isUsingSkill = true
           self:pressedDevourBtnListener()
        elseif event == ccui.TouchEventType.ended  and self.isUsingSkill == true then --松开
           self:releasedDevourBtnListener()
           self.isUsingSkill = false
        elseif event == ccui.TouchEventType.canceled then 
           self:releasedDevourBtnListener(false)
           self.isUsingSkill = false
        end 

    end)
    --技能A键
    self.buttonSkill1 = self.panelSkill:getChildByName("Button_Skill_1")
    self.buttonSkill1:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began and self.isUsingSkill == false then  --按下
           self.isUsingSkill = true
           self:pressedSkillABtnListener()
        elseif event == ccui.TouchEventType.ended  and self.isUsingSkill == true then --松开
           self:releasedSkillABtnListener()
           self.isUsingSkill = false
        elseif event == ccui.TouchEventType.canceled then 
           self:releasedSkillABtnListener(false)
           self.isUsingSkill = false
        end  
    end)

    --技能B键
    self.buttonSkill2 = self.panelSkill:getChildByName("Button_Skill_2")
    self.buttonSkill2:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began and self.isUsingSkill == false then  --按下
           self.isUsingSkill = true
           self:pressedSkillBBtnListener()
        elseif event == ccui.TouchEventType.ended  and self.isUsingSkill == true then --松开
           self:releasedSkillBBtnListener()
           self.isUsingSkill = false
        elseif event == ccui.TouchEventType.canceled then 
           self:releasedSkillBBtnListener(false)
           self.isUsingSkill = false
        end 
    end)

    --技能C键
    self.buttonSkill3 = self.panelSkill:getChildByName("Button_Skill_3")
    self.buttonSkill3:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.began and self.isUsingSkill == false then  --按下
           self.isUsingSkill = true
           self:pressedSkillCBtnListener()
        elseif event == ccui.TouchEventType.ended  and self.isUsingSkill == true then --松开
           self:releasedSkillCBtnListener()
           self.isUsingSkill = false
        elseif event == ccui.TouchEventType.canceled then 
           self:releasedSkillCBtnListener(false)
           self.isUsingSkill = false 
        end 
    end)
    
    --初始化刷新
    self:refreshPlayerInfo()
end

function BattleSceneView:initEvent()
    --刷新面板的角色信息
    self:registerEvent(REFRESH_PLAYER_INFO,function(event)
        self:refreshPlayerInfo()
    end)

    --战斗阶段变化
    self:registerEvent(BATTLE_STAGE_REFRESH,function(event)
          
    end)
end

--刷新UI 面板信息
function BattleSceneView:refreshPlayerInfo()
    
    self.satiationPercent = self.player:getMonsterData():getMonsterSatiationPercent()
    self.evolutionPercent = self.player:getMonsterData():getMonsterEvolutionPercent()

    self.progressBarSatiation:setPercent(self.satiationPercent)
    self.labelSatiation:setString(self.satiationPercent.."%")

    self.progressBarEvolution:setPercent(self.evolutionPercent)
    self.labelEvolution:setString(self.evolutionPercent.."%")

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
        data.initPos = initPosList[i][1]

        local hatchery = mtHatcheryMgr():createHatchery(data)
        self.map:addChild(hatchery,10) 

        mtBattleMgr():addHatcheryToList(hatchery)
     
        local hatcheryPos = self:positionForTileCoord(initPosList[i][2])
        --self.player:moveToward(cc.p(18,7))

        hatchery:setPosition(hatcheryPos)
    end


end

--获得 当前地图
function BattleSceneView:getMap( )
    return self.map
end

function BattleSceneView:getPlayer( )
    return self.player
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

