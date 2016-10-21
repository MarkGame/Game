--[[

   目前还是以单机的形式来做

   战斗的几个阶段
   1、 一开始的准备阶段  BattleStage.init  用来一个倒计时，让玩家快速掌握地图的基本信息
   2、大概三秒钟的倒计时之后，进入第一阶段的战斗 BattleStage.level1 ,此时的最高进化值 小于 总进化值的20%
   3、孵化场开始刷怪 刷怪的怪物池 遵循 按阶段 和 当前怪兽的数量 情况 去刷怪
   4、当最高进化值 在区间 [20,80) 进入阶段二 BattleStage.level2 孵化场的逻辑跟随改变
   5、当最高进化值 在区间 [80,100) 进入阶段三 BattleStage.level3 孵化场的逻辑跟随改变 开始最后狂热阶段
   6、某只怪兽完成进化 抵达100%时，游戏结束 进行结算

   怪兽之间的基本逻辑：
   1、分三大类型，自己玩家控制的怪兽（简称A） ，敌方玩家控制的怪兽（简称B），以及中立怪兽（简称C）
      | A 可以吃 C  |  A 能控制 B 和 C  |
      | B 可以吃 C  |  B 能控制 A 和 C  |
      | C 可以吃 C  |  C 能控制 A 和 B  |
   2、吞噬的逻辑 还是要根据 一些参数去判断，这里目前还是100%去吞噬

   3、



]]

local logicDesc = class("logicDesc",mtBuildNode())

function logicDesc:ctor(hatcheryLogic)
	logicDesc.super.ctor(self)
    
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


function logicDesc:initEvent()
    self:registerEvent(BATTLE_STAGE_REFRESH,function(event)
        --开始刷新一阶段所属怪兽
         --self.hatcheryLogic:updateHatcheryHeart()
    end)
end


function logicDesc:getLogic()
    return self.hatcheryLogic
end


function logicDesc:onEnter()
    logicDesc.super.onEnter(self)
end

function logicDesc:onExit()
    logicDesc.super.onExit(self)

end

return logicDesc

