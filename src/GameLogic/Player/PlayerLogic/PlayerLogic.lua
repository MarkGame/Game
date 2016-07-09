--
-- Author: HLZ
-- Date: 2016-04-29 15:33:31
-- 玩家的通用逻辑
-- 

local PlayerLogic = class("PlayerLogic")

function PlayerLogic:ctor(data)
    
    self.playerData = nil


    --怪兽的吞噬技能
    self.devourSkill = nil 
    
    --最大技能数量 （目前是三个技能按键）
    self.maxSkillCounts = 3
    --流动技能表
    self.flowSkillsList = {}

    --初始化怪兽数据
    self:initPlayerMonsterInfo()

end


function PlayerLogic:initPlayerMonsterInfo( )

    --获得表格里面的怪兽信息
    self.playerMonsterInfo = g_Config:getData(GameConfig.addConfig["Monster"],"ID",1015)[1]

    self.playerMonsterData = mtMonsterBaseInfo().new(self.playerMonsterInfo)
    --需要设置为 是否为主兽
    self.playerMonsterData:setIsMainMonster(true)
    --创建 吞噬技能
    self.devourSkill = mtSkillMgr():createSkill(self.playerMonsterInfo.DevourSkillID)

end

--反向获得 主怪本身的实例
function PlayerLogic:setMonster(monster)
	self.monster = monster
end



--吞噬目标怪兽 这里怪兽只有一只
--根据公式 来计算吞噬的几率
--成功 则执行 目标怪兽的销毁 和 增加对应的饱食度 和 进化值
--失败 则执行 禁锢BUFF 并给目标怪兽 增加不可吞噬的BUFF
function PlayerLogic:devourMonster( )
    self.devourSkill:devourMonster(self.monster)
end

--增加饱食度
function PlayerLogic:addSatiation( value )
	local nowSatiation = self.playerMonsterData:getMonsterNowSatiation()
	local maxSatiation = self.playerMonsterData:getMonsterMaxSatiation()
	
    dump("nowSatiation : "..nowSatiation)
	if nowSatiation + value < maxSatiation then 
	   nowSatiation = nowSatiation + value
	else
       nowSatiation = maxSatiation
       --怪兽完成进化
       --执行 巴拉巴拉 等
	end
	--刷新怪兽的饱食度
	self.playerMonsterData:setMonsterNowSatiation(nowSatiation)
end

--减少饱食度
function PlayerLogic:decSatiation( value )
	local nowSatiation = self.playerMonsterData:getMonsterNowSatiation()
	--如果传入的value为空值 则属于自然扣除饱食度
	if value == nil then 
       value = self.playerMonsterData:getMonsterHungry()
	end
	if nowSatiation - value > 0 then 
	   nowSatiation = nowSatiation - value
	else 
       nowSatiation = 0
       --饱食度为0 怪兽死亡
       --
	end
	--刷新怪兽的饱食度
	self.playerMonsterData:setMonsterNowSatiation(nowSatiation)

end

--增加进化值
function PlayerLogic:addEvolution( value )
	local nowEvolution = self.playerMonsterData:getMonsterNowEvolution()
	local maxEvolution = self.playerMonsterData:getMonsterMaxEvolution()
	if nowEvolution + value < maxEvolution then 
	   nowEvolution = nowEvolution + value
	else
       nowEvolution = maxEvolution
       --完成进化
       --
	end
	self.playerMonsterData:setMonsterNowEvolution(nowEvolution)
end

--创建一个流动技能，需要填入技能ID
function PlayerLogic:createFlowSkill( skillID )
	local newFlowSkill = mtSkillMgr():createSkill(skillID)
	if newFlowSkill then 
       self:addSkillToFlowSkillsList(newFlowSkill)
	end
end

--添加技能到 流动技能数组
function PlayerLogic:addSkillToFlowSkillsList(skill)
	--判断 当前流动技能数组 是否已满
	
	if #self.flowSkillsList < 3 then --当流动技能数组小于三个技能时，可以直接添加 
       table.insert(self.flowSkillsList,skill)
	else --当流动技能数组大于等于三个时，按一定规则删除技能
       self:deleSkillFromFlowSkillsList(1) 
	end

end

--第index号技能从 流动技能数组 删除
function PlayerLogic:deleSkillFromFlowSkillsList(index)
	--技能满的时候，将第一个技能移除，其他技能依次向前移位
	local discardSkill = self.flowSkillsList[index]
	--在技能移除的地方 自身removeFromParent 这里单纯从流动技能表中删除
	--discardSkill:removeSkill()
	table.remove(self.flowSkillsList,index)
    
    if self.flowSkillsList and #self.flowSkillsList > 0 then 
		for k,v in ipairs(self.flowSkillsList) do
			--把flowSkillsList剩余的技能 依次向前移动
			if self.flowSkillsList[1] == nil and k > 1 then 
	           local tempSkill = v
	           table.insert(self.flowSkillsList,1,skill)
			elseif self.flowSkillsList[2] == nil and k > 2 then 
	           local tempSkill = v
	           table.insert(self.flowSkillsList,2,skill)
			elseif self.flowSkillsList[3] == nil then 
	           local tempSkill = v
	           table.insert(self.flowSkillsList,3,skill)
			end
		end
    end
end
--刷新自身的怪兽的 心脏跳动
function PlayerLogic:updateMonsterHeart( )
	-- body
end

function PlayerLogic:getDevourSkill(  )
	return self.devourSkill
end

--获得制定的 流动技能
function PlayerLogic:getFlowSkillByIndex(index)
	if self.flowSkillsList and self.flowSkillsList[index] ~= nil then 
       return self.flowSkillsList[index]
    else
       return nil
	end 
end

--获得主角的主角即时数据
function PlayerLogic:getMonsterData()
   return self.playerMonsterData
end

--设置怪兽出生时间
function PlayerLogic:setMonsterBirthTime(time)
	self.playerMonsterData:setBirthTime(time)
end

return PlayerLogic
