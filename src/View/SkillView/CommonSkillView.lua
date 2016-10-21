--
-- Author: HLZ
-- Date: 2016-08-31 15:29:00
-- 公用技能视图节点

--[[
   这里继承 怪兽的节点 去做移动moveToward
]]
local CommonSkillView = class("CommonSkillView",mtSkillNode())

function CommonSkillView:ctor(skillLogic)
	CommonSkillView.super.ctor(self)
    
    --初始化一张随机图片 用作一个节点
	self.sprite = cc.Sprite:create("publish/resource/1.png")
	self:addChild(self.sprite)
    
    --逻辑
    self.skillLogic = skillLogic
    
end

--初始技能视图
function CommonSkillView:initSkillImage( )

end

--初始化子弹 非子弹类技能 则不需要调用这个
function CommonSkillView:initBullet(speed)
    --这里要设置默认速度
end





return CommonSkillView