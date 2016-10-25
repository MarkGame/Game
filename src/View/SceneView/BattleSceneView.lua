--
-- Author: HLZ
-- Date: 2016-01-06 14:02:56
-- 1V1地图场景


--[[
     
--]]

local BattleSceneView = class("BattleSceneView",mtBattleScene())

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

    self.flowSkillBtnList = {}

    --加载背景图片
    --self.guiBackgroundNode = createGUINode(res.RES_BACKGROUND_ORIGINAL)
    --self.guiBackgroundNode:setName("self.guiBackgroundNode")
    --背景层是不需要动的
    --self:addChild(self.guiBackgroundNode)
    --self.guiNode:setVisible(false)
    --dump(cc.Camera:getDefaultCamera():getPosition())
    
    -- 创建UI层
    self.uiLayer = cc.Layer:create()
    self.uiLayer:setPosition(cc.p(0,0))
    self.uiLayer:setTag(UI_LAYER_TAG)
    self:addChild(self.uiLayer,ZVALUE_UI)

    --创建地图层
    self.mapLayer = cc.Layer:create()
    self.mapLayer:setPosition(cc.p(0,0))
    self.mapLayer:setTag(BATTLEMAP_MAP_LAYER_TAG)
    self:addChild(self.mapLayer,ZVALUE_MAP)




    self.guiBattleMainNode = createGUINode(res.RES_BATTLE_MAIN_UI)
    self.guiBattleMainNode:setName("self.guiBattleMainNode")
    self.uiLayer:addChild(self.guiBattleMainNode)
  
    --加载地图
    self.map = self:createTMXTM(ORIGINAL_SCENCE_64_TMX)
    self.map:setName("self.map")
    self.mapLayer:addChild(self.map,ZVALUE_BATTLEMAP_TMX)
    self.map:setAnchorPoint(cc.p(0,0))    
      
    self.impactLayer = self:getLayer(TiledMapLayer.barrier)
    --self.backGroundLayer = self:getLayer(TiledMapLayer.background)
    self.impactLayer:setVisible(false)
    --self.impactLayer:setOpacity(255*0.8)

    --开启键盘控制（win32版本使用）
    if g_game:getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then 
       self:initKeyBoardListener()
    end

    --摇杆添加
    self.rocker = mtHRocker():createHRocker("publish/resource/close.png", "publish/resource/bg13.png", cc.p(100, 100) ,0.5)
    self.uiLayer:addChild(self.rocker,ZVALUE_ROCKER)
    self.rocker:startRocker(true)

    --开启触摸事件
    --self.player:moveToward(cc.p(25,5))

    --初始化 面板UI
    self:initGUI() 
    --初始化事件
    self:initEvent()
    

    self:hideView()
    
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

    self.behaviorLogBtn = self.guiBattleMainNode:getChildByName("Button_14")
    self.behaviorLogBtn:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then --松开
           local behaviorLogView = mtBehaviorLogView().new()
           self.uiLayer:addChild(behaviorLogView,ZVALUE_UI) 
        end       
    end)
    
    --将三个按钮添加进数组，方便管理和调用
    table.insert(self.flowSkillBtnList,1,self.buttonSkill1)
    table.insert(self.flowSkillBtnList,2,self.buttonSkill2)
    table.insert(self.flowSkillBtnList,3,self.buttonSkill3)
     

end

--这里最好可以通过 事件的推送 来完成一系列的游戏流程
function BattleSceneView:initEvent()

    --准备结束，开始召唤
    self:registerEvent(BATTLE_READYTIME_END,function(event)
        self:hatchStart()
    end)

    --刷新面板的角色信息
    self:registerEvent(REFRESH_PLAYER_INFO,function(event)
        self:refreshPlayerInfo()
    end)

    --战斗阶段变化
    self:registerEvent(BATTLE_STAGE_REFRESH,function(event)
        self:refreshBattleState()  
    end)

    --战斗结束
    self:registerEvent(BATTLE_STATE_END,function(event)
        self:refreshBattleState()
        self:gameOver()  
    end)
    
    --刷新技能的ICON
    self:registerEvent(BATTLE_SKILL_ICON_REFRESH,function(event)
        self:refreshFlowSkillIcon()
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

--刷新当前玩家的流水技能的技能ICON
function BattleSceneView:refreshFlowSkillIcon( )
    for i = 1, 3 do 
        local flowSkill = self.player:getLogic():getFlowSkillByIndex(i)
        --当前位置的技能为空时，删除该位置的技能图标，并将该按钮设为禁用
        if flowSkill == nil then 
           if self.flowSkillBtnList[i] then 
              self.flowSkillBtnList[i]:removeAllChildren()
              self.flowSkillBtnList[i]:setTouchEnabled(false)
           end
        else
           if self.flowSkillBtnList[i] then 
              self.flowSkillBtnList[i]:removeAllChildren()
              self.flowSkillBtnList[i]:setTouchEnabled(true)
              local skillResName = flowSkill:getSkillInfo():getSkillResName()
              local btnSize = self.flowSkillBtnList[i]:getContentSize()
              local iconImage = ccui.ImageView:create(skillResName)
              self.flowSkillBtnList[i]:addChild(iconImage,1)
              iconImage:setAnchorPoint(cc.p(0.5,0.5))
              iconImage:setPosition(cc.p(btnSize.width/2,btnSize.height/2))
           end
        end
    end
end

--孵化开始啦
function BattleSceneView:hatchStart( )

    --创建玩家 和 敌对玩家 
    self.player = mtBattleMgr():createPlayer(cc.p(14,8))
    --self.enemyPlayer = mtBattleMgr():createEnemy(1015,cc.p(15,8))
    --初始化 孵化场
    self:initHatchery()
    --初始化地图位置
    self:initMapPos()
    --初始化刷新
    self:refreshPlayerInfo()
    --开始计时器
    mtBattleMgr():startUpdateBattle()
end

--初始化 孵化场
function BattleSceneView:initHatchery( )
    --这里去读表吧。。
    --已经读表
    local hatcheryCount = mtBattleMgr():getBattleData():getHatcheryCount()
    local hatcheryPosList = mtBattleMgr():getBattleData():getHatcheryPosList()
    local initHatchPosList = mtBattleMgr():getBattleData():getInitHatchPosList()
    
    --test 只放出一个孵化场
    for i =1 ,1 do 
        local data = {}
        data.initPos = hatcheryPosList[i]

        local hatchery = mtHatcheryMgr():createHatchery(data)
        self.map:addChild(hatchery,ZVALUE_BATTLEMAP_HATCHERY) 

        mtBattleMgr():addHatcheryToList(hatchery)
     
        local hatcheryPos = self:positionForTileCoord(initHatchPosList[i])
        --self.player:moveToward(cc.p(18,7))
        hatchery:setPosition(hatcheryPos)
    end
    
end

--刷新战场状态 弹出提示框
function BattleSceneView:refreshBattleState( )
    local str = mtBattleMgr():getBattleStageDesc()
    mtFloatMsgMgr():showTips(str,3)
end

function BattleSceneView:hideView( )
    -- -- 创建遮罩层
    -- local hideLayer = cc.LayerColor:create(cc.c4b(0,0,0,0))
    -- hideLayer:setPosition(cc.p(0,0))
    -- --hideLayer:setTag(UI_LAYER_TAG)
    -- self:addChild(hideLayer,ZVALUE_UI+10)

    self.uiLayer:setVisible(false)
    self.mapLayer:setVisible(false)
end

function BattleSceneView:gameOver( )
    --处理游戏结束时 弹出的界面
end

--获得 当前地图
function BattleSceneView:getMap( )
    return self.map
end

--获得当前玩家
function BattleSceneView:getPlayer( )
    return self.player
end

function BattleSceneView:onEnter()
	BattleSceneView.super.onEnter(self)
    -- print("BattleSceneView onEnter")
    --self:initScene()
end

function BattleSceneView:onExit()
	BattleSceneView.super.onExit(self)
    -- print("BattleSceneView onExit")
end

function BattleSceneView.open()
	local view = BattleSceneView.new()
	view:initScene()
	--这里以后肯定要进行特殊处理
end

return BattleSceneView
