--
-- Author: HLZ
-- Date: 2016-04-29 15:33:31
-- 玩家的通用逻辑
-- 

local PlayerLogic = class("PlayerLogic")

function PlayerLogic:ctor(data)

    self.sceneParent = data.parent

    self.playerData = mtPlayerBaseInfo().new()
   

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

    self.playerData:setMonsterData(self.playerMonsterInfo)

    --创建 吞噬技能
    self.devourSkill = mtSkillMgr():createSkill(self.playerMonsterInfo.DevourSkillID)

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
	--discardSkill:removeSkill()
	table.remove(self.flowSkillsList,index)
    
    if self.flowSkillsList and #self.flowSkillsList > 1 then 
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

--获得制定的 流动技能
function PlayerLogic:getFlowSkillByIndex(index)
	if self.flowSkillsList and self.flowSkillsList[index] ~= nil then 
       return self.flowSkillsList[index]
    else
       return nil
	end 
end

--获得主角的即时数据
function PlayerLogic:getPlayerData()
   return self.playerData
end

--获得父场景
function PlayerLogic:getSceneParent( )
   return self.sceneParent
end

return PlayerLogic
