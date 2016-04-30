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
	--self.sprite:setPositionY(-32)
   
    --父场景 
	self:setParentScene(hatcheryLogic:getParentScene())

    --self.parentScene = data.parent
	self.map = self.parentScene:getMap()
	self.initPos = hatcheryLogic:getInitPos()
    
    
    hatcheryLogic:refreshMonster()
end


function HatcheryView:initEvent()
    self:registerEvent(HATCHERY_START_LV1_MONSTER,function(event)
        --开始刷新怪兽
    hatcheryLogic:refreshMonster()
    end)
end

function HatcheryView:onEnter()
    HatcheryView.super.onEnter(self)
end

function HatcheryView:onExit()
    HatcheryView.super.onExit(self)

    if self.updateRefreshMonster ~= nil  then
       g_scheduler:unscheduleScriptEntry(self.updateRefreshMonster);
       self.updateRefreshMonster = nil 
    end
end

return HatcheryView








