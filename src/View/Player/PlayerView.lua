--
-- Author: HLZ
-- Date: 2016-01-07 20:19:31
-- 玩家角色视图节点


--[[
    玩家自身的一个节点
    
--]]

local PlayerView = class("PlayerView",PlayerNode)

function PlayerView:ctor(playerLogic)
	PlayerView.super.ctor(self)

	self.sprite = cc.Sprite:create("publish/resource/1.png")
	self:addChild(self.sprite)

	self.sprite:setAnchorPoint(cc.p(0.5,0.5))

    self.playerLogic = playerLogic

    self:initPlayer()
    --父场景
	self:setParentScene(self.playerLogic:getSceneParent())

end
    --self.sprite:setPositionY(32)

    --设置节点

    -- local body = cc.PhysicsBody:createBox(cc.size(32,32), cc.PhysicsMaterial(0.0, 0.0, 0.0), cc.p(0,0))
 --    self:setPhysicsBody(body)

 --    body:setRotationEnable(false)


    --self:getPhysicsBody():setGravityEnable(false)
    --dict:getPhysicsBody():getVelocity().x
    --dict:getPhysicsBody():setVelocity(cc.p(-70, math.random(-40, 40)))


function PlayerView:initPlayer()

	--初始化玩家信息 以后可能是在加载中进行数据加载
	-- local data = {}
	self.playerData = self.playerLogic:getPlayerData()

 --    self.powerValue = self.playerInfo:getPlayerPowerValue()
 --    self.speedValue = self.playerInfo:getPlayerSpeedValue()
 --    self.energyValue = self.playerInfo:getPlayerEnergyValue()

	--初始化怪兽信息 以后可能是在加载中进行数据加载
    self:initAnim(self.playerData:getMonsterResName(), self.playerData:getMonsterAnimName())
   
    self:playAnim(AnimationType.walkD)
	--self:initStateMachine()

    --设置技能 
    self.skill = mtSkillMgr():createSkill(10001)

    self:setSkillRangeDiagram(self.skill:getSkillRangeDiagram())

   
    if self.updateRefreshMonster ~= nil  then
        g_scheduler:unscheduleScriptEntry(self.updateRefreshMonster);
        self.updateRefreshMonster = nil 
    end
   
    self.updateRefreshMonster = g_scheduler:scheduleScriptFunc(handler(self,self.detectMonster),1,false)

end

function PlayerView:detectMonster(  )
     --dump(mtBattleMgr():detectMonster(self:getTiledMapPos(),self.skill:getSkillRangeInfo()))
end

function PlayerView:initEvent()

end

function PlayerView:onEnter()
    PlayerView.super.onEnter(self)
end

function PlayerView:onExit()
    PlayerView.super.onExit(self)
    --self:doEventForce("stop")
    if self.updateRefreshMonster ~= nil  then
        g_scheduler:unscheduleScriptEntry(self.updateRefreshMonster);
        self.updateRefreshMonster = nil 
    end
end

return PlayerView





