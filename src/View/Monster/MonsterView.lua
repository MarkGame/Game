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
    --2016年5月3日00:26:14的我：在场景直接加是好的，在中间出现了问题
	-- self.sprite:setAnchorPoint(cc.p(0.6,1))
	-- self.sprite:setPositionY(-32)
    
    --怪兽逻辑
    self.monsterLogic = monsterLogic
    self.monsterLogic:setMonster(self)

	self.monsterID = monsterLogic:getMonsterID()

    self:initMonster()
    
	--现在十秒就杀死怪兽（暂时的）
	--self:killMonster()

end


function MonsterView:initMonster()

    self.monsterInfo = self.monsterLogic:getMonsterInfo()
	--初始化怪兽信息 以后可能是在加载中进行数据加载
	self:initAnim(self.monsterInfo.ResName,self.monsterInfo.AnimName)--resName,animName)
    
    self:playAnim(AnimationType.walkD)
	--self:initStateMachine()
    self:initMonsterInfo()
    
    --test 探测技能
    --self.monsterLogic:getDevourSkill():showSkillRangeDiagram(self)

end

function MonsterView:killMonster( )


    self.updateRefreshMonster = mtSchedulerMgr():removeScheduler(self.updateRefreshMonster)


    self.updateRefreshMonster = mtSchedulerMgr():addScheduler(5,-1,handler(self,self.removeMonster))

end

function MonsterView:removeMonster()

	g_Worker:pushDelayQueue(function()
        --从当前场上存活的怪兽移除
        self.monsterLogic:removeMonster()
        self:removeFromParent()           
    end)
    --self.monsterLogic:devourMonster()
end

function MonsterView:getLogic(  )
    return self.monsterLogic
end

function MonsterView:initEvent()

end

function MonsterView:onEnter()
    MonsterView.super.onEnter(self)
end

function MonsterView:onExit()
    MonsterView.super.onExit(self)

    self.updateRefreshMonster = mtSchedulerMgr():removeScheduler(self.updateRefreshMonster)

    mtBattleMgr():removeMonsterFromList(self)
    self:removeMonster()
    
end

return MonsterView







