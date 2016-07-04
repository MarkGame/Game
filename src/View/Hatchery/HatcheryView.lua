--
-- Author: HLZ
-- Date: 2016-04-24 02:00:31
-- 孵化场视图节点
--

local HatcheryView = class("HatcheryView",HatcheryNode)

function HatcheryView:ctor(hatcheryLogic)
	HatcheryView.super.ctor(self)
    
    --初始化一张随机图片 用作一个节点
    local num = math.random(1,2)
    local icon = "publish/resource/Hatchery/Hatchery_"..num..".png"
	self.sprite = cc.Sprite:create(icon)
	self:addChild(self.sprite)

	self.sprite:setAnchorPoint(cc.p(0.25,0.2))
    local size = self.sprite:getContentSize()
	self.sprite:setPositionY(-size.height/2-10)

    self.parentScene = mtBattleMgr():getScene()
	self.map = self.parentScene:getMap()
	self.initPos = hatcheryLogic:getInitPos()

    self.hatcheryLogic = hatcheryLogic
    
    self.hatcheryLogic:produceMonster()
end


function HatcheryView:initEvent()
    self:registerEvent(BATTLE_STAGE_REFRESH,function(event)
        --开始刷新一阶段所属怪兽
         self.hatcheryLogic:produceMonster()
    end)
end


function HatcheryView:getLogic()
    return self.hatcheryLogic
end


function HatcheryView:onEnter()
    HatcheryView.super.onEnter(self)
end

function HatcheryView:onExit()
    HatcheryView.super.onExit(self)

end

return HatcheryView








