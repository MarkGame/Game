--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 怪兽视图节点

--[[
    怪兽 和 玩家的视图继承类 还是分开
    
--]]

local MonsterView = class("MonsterView",mtMonsterNode())

function MonsterView:ctor(monsterLogic)
	MonsterView.super.ctor(self)
    
    --怪兽逻辑
    self.monsterLogic = monsterLogic
    --初始化 头顶饱食度
    self.satiationLabel = nil

    self.nowSatiation = 0

    self:initMonster()
    
    self.monsterLogic:initMonsterBrain(self)

	self.monsterID = monsterLogic:getMonsterID()

	--现在十秒就杀死怪兽（暂时的）
	--self:killMonster()

end


function MonsterView:initMonster()
    
    --初始化一张随机图片 用作一个节点
    self.sprite = cc.Sprite:create("publish/resource/transparent.png")
    self:addChild(self.sprite)

    self.monsterInfo = self.monsterLogic:getMonsterInfo()
	--初始化怪兽信息 以后可能是在加载中进行数据加载
	self:initAnim(self.monsterInfo.ResName,self.monsterInfo.AnimName)--resName,animName)
    
    self:playAnim(AnimationType.walkD)
	--self:initStateMachine()
    self:initBaseInfo()
    
    --test 探测技能
    --self.monsterLogic:getDevourSkill():showSkillRangeDiagram(self)

end

function MonsterView:killMonster( )

    self.updateRefreshMonster = mtSchedulerMgr():removeScheduler(self.updateRefreshMonster)
    
    self.updateRefreshMonster = mtSchedulerMgr():addScheduler(5,-1,handler(self,self.removeMonster))
end

function MonsterView:removeMonster()

	g_Worker:pushDelayQueue(function()
        -- 从当前场上存活的怪兽移除
        if self and self.monsterLogic then 
           self.monsterLogic:removeMonster() 
        end
    end)
    --self.monsterLogic:devourMonster()
end

function MonsterView:getLogic(  )
    return self.monsterLogic
end

function MonsterView:initEvent()

end

--怪物不同行为 使用不同的表情
function MonsterView:showExpression( res )
    --删除上一个表情
    if self.expression then
       self.expression:removeFromParent()
       self.expression = nil
    end
    --
    self.expression = ccui.ImageView:create(res)
    self.expression:setPositionY(40)
    self:addChild(self.expression)
end

--展示怪物头上的饱食度（生命值）
function MonsterView:showSatiation( satiation )
    if self.nowSatiation ~= satiation then  
        if self.satiationLabel then 
           self.satiationLabel:removeFromParent()
           self.satiationLabel = nil 
        end

        if self.satiationLabel == nil then 
           self.satiationLabel = ccui.TextAtlas:create( tostring(satiation), "fonts/WZ_huifu.png", 24, 38, "+" );
           self.satiationLabel:setScale(1.5)
           self.satiationLabel:stopAllActions()
           self.satiationLabel:setPositionY(60)
           self:addChild(self.satiationLabel)
           local action1 = cc.ScaleTo:create(0.3, 1)
           local callfunc = cc.CallFunc:create(function() 
                if self.satiationLabel then 
                   self.satiationLabel:removeFromParent()
                   self.satiationLabel = nil 
                end
           end)
           self.satiationLabel:runAction(cc.Sequence:create(action1, callfunc))
        end 
        self.nowSatiation = satiation
    end
end

function MonsterView:onEnter()
    MonsterView.super.onEnter(self)
end

function MonsterView:onExit()
    MonsterView.super.onExit(self)

    self.updateRefreshMonster = mtSchedulerMgr():removeScheduler(self.updateRefreshMonster)

    mtBattleMgr():removeMonsterFromList(self)
    
end

return MonsterView







