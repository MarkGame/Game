--
-- Author: HLZ
-- Date: 2016-04-22 18:52:31
-- 技能的通用逻辑
-- 
--[[
    技能类型需要有两种： 【主动技能】 和 【被动技能】 
    该类只处理   【主动技能】
    存放的技能分 【固定技能】   一旦创建 就不会删除  目前只有 吞噬devour和 探测 Detect
                 【流动技能】   随着增加，删除

]]

local CommonSkillLogic = class("CommonSkillLogic")

function CommonSkillLogic:ctor(skillID)
    
    self.skillID = skillID
    --技能的范围显示
    self.skillRangeDiagram = nil

    self:initSkillData()
end

--设置技能的持有者
function CommonSkillLogic:setOwner(owner)
    self.owner = owner
end

--初始化技能数据
function CommonSkillLogic:initSkillData(  )

    self.skillInfo = g_Config:getData(GameConfig.addConfig["Skill"],"ID",self.skillID)[1]
    
    	
    self.skillRangeInfo = g_Config:getData2(GameConfig.addConfig["SkillRange"],{{key = "SkillRangeType",value = self.skillInfo.SkillRangeType},{key = "SkillRange",value = self.skillInfo.SkillRange}})[1]
    --dump(skillRangeInfo)
end


--获得技能的信息
function CommonSkillLogic:getSkillInfo(  )
	return self.skillInfo
end

--获得技能范围信息
function CommonSkillLogic:getSkillRangeInfo( )
	return self.skillRangeInfo
end


--[[
    
    及时查找 技能范围 或 探测范围 内 是否有 其他怪兽

    返回 在范围内存活的怪兽数组 

    initPos     探测原点坐标

    skillRangeType  探测类型 技能的探测类型

]]
function CommonSkillLogic:getDetectMonsterBySkill(monster)
	mtBattleMgr():detectMonster(monster:getTiledMapPos(),self:getSkillRangeInfo())
end

--获得技能内 最近的一个/多个目标 
--从近到远，并且满足
function CommonSkillLogic:getTargetMonster(monster)
    --先获得技能内的怪兽 如果存在怪兽 则继续执行 否则 返回false
    --根据技能的使用范围
    local monsterList = self:getDetectMonsterBySkill(monster)
    if monsterList and #monsterList > 0 then
       --数组里面第一个怪兽 就是距离最近的 在范围数组里面已经做过了处理
       return monsterList[1] 
    else 
       return nil 
    end
end


--显示（创建）技能提示范围
function CommonSkillLogic:showSkillRangeDiagram(monster)
	if self.skillRangeDiagram then return end

    self.skillRangeDiagram = self:getSkillRangeDiagram()

    self.skillRangeDiagram:setAnchorPoint(cc.p(0.4,1))
    --local size = self:getContentSize()
    self.skillRangeDiagram:setPosition(cc.p(0,-50))
    monster:addChild(self.skillRangeDiagram,10)
end

--隐藏（删除）技能提示范围
function CommonSkillLogic:hideSkillRangeDiagram()
	if self.skillRangeDiagram then 
       self.skillRangeDiagram:removeFromParent()
       self.skillRangeDiagram = nil 
	end
end

--获得技能范围的显示框
function CommonSkillLogic:getSkillRangeDiagram()
    return mtSkillDetect():getSkillRangeDiagram(self.skillRangeInfo)
end



return CommonSkillLogic
