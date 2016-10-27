--
-- Author: HLZ
-- Date: 2016-06-16 16:52:31
-- 行为日志的基本结构体

local BehaviorLogInfo = class("BehaviorLogInfo")

function BehaviorLogInfo:ctor( data )

    self.index = data.index

    self.behaviorType = data.behaviorType 
    self.monsterLogID = data.monsterLogID
    self.monsterType  = data.monsterType
    self.behaviorTime = mtTimeMgr():getStrByTimestamp(mtTimeMgr():getCurTime())
    
end

function BehaviorLogInfo:getMonsterLogID( )
    return self.monsterLogID
end

function BehaviorLogInfo:getBehaviorStr( )

	if self.behaviorType == MonsterBehaviorType.idle then 
       return "等待状态"
	elseif self.behaviorType == MonsterBehaviorType.search then
       return "正在搜寻目标"
	elseif self.behaviorType == MonsterBehaviorType.selectTarget then
       return "已找到目标，正在选取"
	elseif self.behaviorType == MonsterBehaviorType.autoMove then 
       return "自动移动中……"
	elseif self.behaviorType == MonsterBehaviorType.chase then 
       return "追捕目标中……"
	elseif self.behaviorType == MonsterBehaviorType.escape then 
       return "逃跑中……"
	elseif self.behaviorType == MonsterBehaviorType.devour then 
       return "正在吞噬目标……"
	elseif self.behaviorType == MonsterBehaviorType.useExclusive then 
       return "使用了专属技能"
  elseif self.behaviorType == MonsterBehaviorType.die then 
       return "死亡"
	end
  return ""
end

PlayerType = {
  player = 1,
  enemy  = 2,

function BehaviorLogInfo:getMonsterName( )
  if self.monsterType == PlayerType.player then 
     return "己方怪兽"
  elseif self.monsterType == PlayerType.enemy then 
     return "敌对怪兽"
  elseif self.monsterType == PlayerType.npc then
     return self.monsterLogID.."号怪兽"   
  end
  return "error"
end

function BehaviorLogInfo:getLogStr( )
	local behaviorStr = self:getBehaviorStr()
  local monsterName = self:getMonsterName()
	return self.index.." : ".. monsterName .."，在"..self.behaviorTime.." 执行了——"..behaviorStr
end

return BehaviorLogInfo


