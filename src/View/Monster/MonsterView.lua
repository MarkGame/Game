--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 怪兽视图节点

--[[
    怪兽 和 玩家的视图继承类 还是分开
    
--]]

local MonsterView = class("MonsterView",MonsterNode)

function MonsterView:ctor(monsterLogic)
	MonsterView.super.ctor(self)
    
    --初始化一张随机图片 用作一个节点
	self.sprite = cc.Sprite:create("publish/resource/1.png")
	self:addChild(self.sprite)
    
    --为什么怪兽这里会偏移位置显示？？？
    --2016年4月29日16:33:27的我：然而目前还没找到原因
	self.sprite:setAnchorPoint(cc.p(0.6,1))
	self.sprite:setPositionY(-32)
    
    --怪兽逻辑
    self.monsterLogic = monsterLogic
    self.monsterLogic:setMonster(self)

    --父场景 
    self:setParentScene(monsterLogic:getSceneParent())

	self.monsterID = monsterLogic:getMonsterID()

    self:initMonster()
    
	--现在十秒就杀死怪兽（暂时的）
	self:killMonster()

end


function MonsterView:initMonster()
    

    self.monsterInfo = self.monsterLogic:getMonsterInfo()
    

	--初始化怪兽信息 以后可能是在加载中进行数据加载
	self:initAnim(self.monsterInfo.ResName,self.monsterInfo.AnimName)--resName,animName)
    
    self:playAnim(AnimationType.walkD)
	--self:initStateMachine()
    
    --test 探测技能
    self.monsterLogic:getDetectSkill():showSkillRangeDiagram(self)

end

function MonsterView:killMonster( )
	if self.updateRefreshMonster ~= nil  then
        g_scheduler:unscheduleScriptEntry(self.updateRefreshMonster);
        self.updateRefreshMonster = nil 
    end
   
    self.updateRefreshMonster = g_scheduler:scheduleScriptFunc(handler(self,self.removeMonster),5,false)
end

function MonsterView:removeMonster()

    --这里需要做 延迟一帧 remove  今晚太晚了 明天起来加 。2016年4月24日02:38:16
    --2016年4月27日01:22:39 嗯 加好了
	-- g_Worker:pushDelayQueue(function()
 --        self:removeFromParent()           
 --    end)
    self.monsterLogic:devourMonster()
end

function MonsterView:getMonsterLogic(  )
    return self.monsterLogic
end

function MonsterView:initEvent()

end

function MonsterView:onEnter()
    MonsterView.super.onEnter(self)
end

function MonsterView:onExit()
    MonsterView.super.onExit(self)
    if self.updateRefreshMonster ~= nil  then
        g_scheduler:unscheduleScriptEntry(self.updateRefreshMonster);
        self.updateRefreshMonster = nil 
    end
end

return MonsterView







