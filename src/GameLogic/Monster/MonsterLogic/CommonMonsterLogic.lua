--
-- Author: HLZ
-- Date: 2016-04-24 15:33:31
-- 怪兽的通用逻辑
-- 

local CommonMonsterLogic = class("CommonMonsterLogic")

function CommonMonsterLogic:ctor(data)

   self.sceneParent = data.parent
   self.monsterID = data.monsterID
   
   --怪兽的基本信息
   self.monsterInfo = nil
   
   --怪兽的吞噬技能
   self.devourSkill = nil 
   --怪兽的探测技能
   self.detectSkill = nil
   --怪兽的专属技能 
   self.exclusiveSkill = nil

   --初始化 怪兽信息
   self:initMonsterInfo()
   
end

--初始化 怪兽信息
function CommonMonsterLogic:initMonsterInfo( )
	  --获得表格里面的怪兽信息
	  self.monsterInfo = g_Config:getData(GameConfig.addConfig["Monster"],"ID",self.monsterID)[1]
    
    self.monsterData = mtMonsterBaseInfo().new(self.monsterInfo)
    --初始技能
	  self:initMonsterSkill()
end

--获得怪兽的即时数据
function CommonMonsterLogic:getMonsterData()
	return self.monsterData
end

--初始化 怪兽技能 一般是三个
function CommonMonsterLogic:initMonsterSkill( )

    --创建 吞噬技能
	  self.devourSkill = mtSkillMgr():createSkill(self.monsterInfo.DevourSkillID)

	--创建 探测技能  
    self.detectSkill = mtSkillMgr():createSkill(self.monsterInfo.DetectSkillID)

    --创建 专属技能
    self.exclusiveSkill = mtSkillMgr():createSkill(self.monsterInfo.ExclusiveSkillID)

end

--吞噬目标怪兽 这里怪兽只有一只
--根据公式 来计算吞噬的几率
--成功 则执行 目标怪兽的销毁 和 增加对应的饱食度 和 进化值
--失败 则执行 禁锢BUFF 并给目标怪兽 增加不可吞噬的BUFF
function CommonMonsterLogic:devourMonster( )
   local targetMonster = self.devourSkill:getTargetMonster(self.monster)
   --先判断 目标怪兽 是否有 不可吞噬的BUFF
   if targetMonster then 
       local satiation = targetMonster:getMonsterLogic():getMonsterData():getMonsterSatiation()
       local evolution = targetMonster:getMonsterLogic():getMonsterData():getMonsterEvolution()

       print("satiation  :"..satiation.."evolution :"..evolution)
   
       self:addSatiation(satiation)
       self:addEvolution(evolution)

       targetMonster:removeMonster()
   else 
       print("目标怪兽不存在")
   end	
   
end

--增加饱食度
function CommonMonsterLogic:addSatiation( value )
    local nowSatiation = self.monsterData:getMonsterNowSatiation()
	if nowSatiation + value < 100 then 
	   nowSatiation = self.nowSatiation + value
	else
       nowSatiation = 100
       --怪兽完成进化
       --执行 巴拉巴拉 等
	end
	--刷新怪兽的饱食度
	self.monsterData:setMonsterNowSatiation(nowSatiation)
end

--减少饱食度
function CommonMonsterLogic:decSatiation( value )
	local nowSatiation = self.monsterData:getMonsterNowSatiation()
	if nowSatiation - value > 0 then 
	   nowSatiation = nowSatiation - value
	else 
       nowSatiation = 0
       --饱食度为0 怪兽死亡
       --
	end
	--刷新怪兽的饱食度
	self.monsterData:setMonsterNowSatiation(nowSatiation)
end

--增加进化值
function CommonMonsterLogic:addEvolution( value )
	local nowEvolution = self.monsterData:getMonsterNowEvolution()
	if nowEvolution + value < 100 then 
	   nowEvolution = nowEvolution + value
	else
       nowEvolution = 100
       --完成进化
       --
	end
	self.monsterData:setMonsterNowEvolution(nowEvolution)
end


--反向获得 怪兽本身的实例
function CommonMonsterLogic:setMonster(monster)
	self.monster = monster
end

--获得 吞噬技能
function CommonMonsterLogic:getDevourSkill( )
	return self.devourSkill
end

--获得 探测技能 
function CommonMonsterLogic:getDetectSkill( )
	return self.detectSkill
end

--获得 专属技能
function CommonMonsterLogic:getExclusiveSkill( )
	return self.exclusiveSkill
end

--获得怪兽信息
function CommonMonsterLogic:getMonsterInfo( )
	return self.monsterInfo
end

--获得父场景
function CommonMonsterLogic:getSceneParent( )
	return self.sceneParent
end

--获得怪兽ID
function CommonMonsterLogic:getMonsterID( )
	return self.monsterID
end

return CommonMonsterLogic