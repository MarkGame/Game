--
-- Author: HLZ
-- Date: 2016-01-07 20:19:31
-- 玩家角色视图节点


--[[
    玩家自身的一个节点
    
--]]

local PlayerView = class("PlayerView",mtPlayerNode())

function PlayerView:ctor(playerLogic)
	PlayerView.super.ctor(self)

	self.sprite = cc.Sprite:create("publish/resource/1.png")
	self:addChild(self.sprite)

	self.sprite:setAnchorPoint(cc.p(0.5,0.5))

    self.playerLogic = playerLogic
    self.playerLogic:setMonster(self)

    --设置名字
    self:setName("Player")

    self:initPlayer()

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
	self.playerMonsterData = self.playerLogic:getMonsterData()

 --    self.powerValue = self.playerInfo:getPlayerPowerValue()
 --    self.speedValue = self.playerInfo:getPlayerSpeedValue()
 --    self.energyValue = self.playerInfo:getPlayerEnergyValue()

	--初始化怪兽信息 以后可能是在加载中进行数据加载
    self:initAnim(self.playerMonsterData:getMonsterResName(), self.playerMonsterData:getMonsterAnimName())
   
    self:playAnim(AnimationType.walkD)

    --初始化 怪物数据
    self:initBaseInfo()
	--self:initStateMachine()

    --设置技能 
    --self.skill = mtSkillMgr():createSkill(10001)

    --self.playerLogic:getDevourSkill():showSkillRangeDiagram(self)

end

function PlayerView:detectMonster(  )
     --dump(mtBattleMgr():detectMonster(self:getTiledMapPos(),self.skill:getSkillRangeInfo()))
end

function PlayerView:initEvent()

end

function PlayerView:getLogic(  )
    return self.playerLogic
end

function PlayerView:getMonsterData(  )
    return self.playerMonsterData
end

function PlayerView:onEnter()
    PlayerView.super.onEnter(self)
end

function PlayerView:onExit()
    PlayerView.super.onExit(self)
    --self:doEventForce("stop")


    --关闭摄像机跟随
  self:stopUpdateCamera()
end

return PlayerView





