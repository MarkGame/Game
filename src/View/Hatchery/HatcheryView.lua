--
-- Author: HLZ
-- Date: 2016-04-24 02:00:31
-- 孵化场视图节点
--

local HatcheryView = class("HatcheryView",mtBuildNode())

function HatcheryView:ctor(hatcheryLogic)
	HatcheryView.super.ctor(self)
    
    --初始化一张随机图片 用作一个节点
    local num = math.random(1,2)
    local icon = "publish/resource/Hatchery/Hatchery_"..num..".png"
	self.sprite = cc.Sprite:create(icon)
	self:addChild(self.sprite)

    self.parentScene = mtBattleMgr():getScene()
	self.map = self.parentScene:getMap()
	self.initPos = hatcheryLogic:getInitPos()

    self.hatcheryLogic = hatcheryLogic
    
    --self.hatcheryLogic:updateHatcheryHeart()
end


function HatcheryView:initEvent()
    self:registerEvent(BATTLE_STAGE_REFRESH,function(event)
        --开始刷新一阶段所属怪兽
         --self.hatcheryLogic:updateHatcheryHeart()
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








