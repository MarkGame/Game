--
-- Author: HLZ
-- Date: 2016-08-29 16:18:00
-- 子弹视图节点

--[[
   这里继承 怪兽的节点 去做移动moveToward
]]
local CommonBulletView = class("CommonBulletView",mtMonsterNode())

function CommonBulletView:ctor(skillLogic)
	CommonBulletView.super.ctor(self)
    
    --初始化一张随机图片 用作一个节点
	self.sprite = cc.Sprite:create("publish/resource/1.png")
	self:addChild(self.sprite)
    
    --怪兽逻辑
    self.skillLogic = skillLogic

    self:initBullet()
    
end

function CommonBulletView:initBullet( )
    -- body
    --这里要设置默认速度
    self:initBaseInfo(600)
end

return CommonBulletView