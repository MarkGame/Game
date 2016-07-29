--
-- Author: HLZ
-- Date: 2016-04-24 02:00:31
-- 孵化场视图节点
--

local YggdrasilView = class("YggdrasilView",mtBuildNode())

function YggdrasilView:ctor(yggdrasilLogic)
	YggdrasilView.super.ctor(self)
    
    --初始化一张随机图片 用作一个节点
    local num = math.random(1,2)
    local icon = "publish/resource/Hatchery/Hatchery_"..num..".png"
	self.sprite = cc.Sprite:create(icon)
	self:addChild(self.sprite)

    self.parentScene = mtBattleMgr():getScene()
	self.map = self.parentScene:getMap()
	self.initPos = yggdrasilLogic:getInitPos()

    self.yggdrasilLogic = yggdrasilLogic
    
    --self.yggdrasilLogic:updateHatcheryHeart()
end


function YggdrasilView:initEvent()
    -- self:registerEvent(BATTLE_STAGE_REFRESH,function(event)

    -- end)
end


function YggdrasilView:getLogic()
    return self.yggdrasilLogic
end


function YggdrasilView:onEnter()
    YggdrasilView.super.onEnter(self)
end

function YggdrasilView:onExit()
    YggdrasilView.super.onExit(self)

end

return YggdrasilView








