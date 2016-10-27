--
-- Author: HLZ
-- Date: 2016-04-22 18:52:31
-- 技能的通用逻辑
-- 
--[[
    技能类型需要有三种： 【探测技能】 【吞噬技能】 【专属技能】 
    该类只处理   【探测技能】 【吞噬技能】 以及创建每种专属技能
                  
    存放的技能分 【固定技能】   一旦创建 就不会删除  目前只有 吞噬devour和 探测 Detect
                 【流动技能】   随着增加，删除

]]

local CommonSkillLogic = class("CommonSkillLogic")

function CommonSkillLogic:ctor()
  
end

function CommonSkillLogic:init(data)

    self.skillID = data.skillID
    --技能的范围显示
    self.skillRangeDiagram = nil

    self.buff = nil

    self.parentScene = mtBattleMgr():getScene()
    
    --技能CD冷却结束的时间
    self.skillCDCompleteTime = 0
    
    --技能CD冷却剩余时间
    self.residualTime = 0

    self:initSkillData()
end

--设置技能的持有者
function CommonSkillLogic:setOwner(owner)
    self.owner = owner
end

--初始化技能数据
function CommonSkillLogic:initSkillData(  )

    self.skillInfo = g_Config:getData("Skill","ID",self.skillID)[1]
    
    self.skillData = mtSkillBaseInfo().new(self.skillInfo)

    self.skillRangeInfo = g_Config:getData2("SkillRange",{{key = "SkillRangeType",value = self.skillInfo.SkillRangeType},{key = "SkillRange",value = self.skillInfo.SkillRange}})[1]
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

function CommonSkillLogic:getSkillData( )
  return self.skillData
end

--是否是一次性技能(用完即删)
function CommonSkillLogic:isDisposableSkill( )
    local skillType = self.skillData:getSkillType()
    if skillType == SkillType.disposable then 
       --判断拥有者是否为玩家，如果是玩家则自动移除，普通怪兽则不移除
       if self.owner:getLogic():getMonsterData():getIsMainMonster()== true then 
          return true
       else
          return false
       end
    else
       return false
    end
end

--启动技能 在每个单独技能中重新定义
--这里的monster是释放技能的怪物本身
--targetMonster = self:getTargetMonster(monster) 是指释放技能的怪物找到了目标怪兽
--index 为流动技能的序号
function CommonSkillLogic:launch(monster,index)
  
end

--终止并清除技能
--适用于强制清除技能
function CommonSkillLogic:stopAndClearSkill( )
   
end

--移除技能
--一次性使用技能 使用之后，自我删除
function CommonSkillLogic:removeSkill(index)
  -- body
end

--技能的冷却CD计算
function CommonSkillLogic:refreshSkillCD(  )
    local nowTime = mtTimeMgr():getMSTime()
    
    if nowTime >= self.skillCDCompleteTime then 
       
       self.updateSkillCDHandler = mtSchedulerMgr():removeScheduler(self.updateSkillCDHandler)
       self.residualTime = 0
       
    else
       self.residualTime = math.max(nowTime-self.skillCDCompleteTime,0) 
    end
end

--开始计算技能冷却CD
function CommonSkillLogic:startSkillCD( )
    
    self.residualTime = self.skillData:getSkillCD()

    self.skillCDCompleteTime = mtTimeMgr():getMSTime() + self.skillData:getSkillCD()
    
    self.updateSkillCDHandler = mtSchedulerMgr():removeScheduler(self.updateSkillCDHandler)

    self.updateSkillCDHandler = mtSchedulerMgr():addScheduler(0.1,-1,handler(self,self.refreshSkillCD))

end

--活动当前的技能剩余冷却时间
function CommonSkillLogic:getResidualTime( )
    return self.residualTime
end



--[[
    
    及时查找 技能范围 或 探测范围 内 是否有 其他怪兽

    返回 在范围内存活的怪兽数组 

    initPos     探测原点坐标

    skillRangeType  探测类型 技能的探测类型

    monster 是释放者 本身？
 
]]
function CommonSkillLogic:getDetectMonsterBySkill(monster)
    if monster == nil then return end 
    --dump(monster)
    local monsterID = monster:getLogic():getMonsterID()
    --print(" monsterID : "..monsterID)
    local pos = monster:getTiledMapPos()
    local skillRangeInfo = self:getSkillRangeInfo()
	  return mtBattleMgr():detectMonster(pos,skillRangeInfo)
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

--判断在技能范围内是否存在指定怪兽
function CommonSkillLogic:isTargetInDetectList(monster,target)
    local monsterList = self:getDetectMonsterBySkill(monster)
    local isFind = false
    if monsterList and #monsterList > 0 then
       for k,v in ipairs(monsterList) do
          --找到了 当前目标 
          if v and v == target then 
             isFind = true 
             break
          end
       end
    end
    return isFind
end


--显示（创建）技能提示范围
function CommonSkillLogic:showSkillRangeDiagram(monster)
	if self.skillRangeDiagram then return end

    self.skillRangeDiagram = self:getSkillRangeDiagram()

    -- --if monster:getName() ~= "Player" then 
    --     self.skillRangeDiagram:setAnchorPoint(cc.p(0.4,1))
    --     --local size = self:getContentSize()
    --     self.skillRangeDiagram:setPosition(cc.p(0,-50))
    -- --end

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

------------------------------------------吞噬逻辑---------------------------------------------------

--吞噬目标怪兽 这里怪兽只有一只
--根据公式 来计算吞噬的几率
--成功 则执行 目标怪兽的销毁 和 增加对应的饱食度 和 进化值
--失败 则执行 禁锢BUFF 并给目标怪兽 增加不可吞噬的BUFF
--【只适用于 吞噬技能 ，其他技能请不要使用】
function CommonSkillLogic:devourMonster(monster,callBack)
   --应该判断一下 当前技能是否属于吞噬技能，不属于则无效并提示
   local targetMonster = self:getTargetMonster(monster)
   --先判断 目标怪兽 是否有 不可吞噬的BUFF
   if targetMonster then 
       if self:canIEat(monster,targetMonster) == true then 
          self:devourMonsterSuccess(monster,targetMonster,callBack)
       else
          self:devourMonsterFail(monster,targetMonster,callBack)
       end
   else 
       print("目标怪兽不存在")
   end  
   
end

--返回吞噬结果 
function CommonSkillLogic:canIEat( monster,targetMonster )
   return true
end

--吞噬怪兽成功
function CommonSkillLogic:devourMonsterSuccess( monster,targetMonster,callBack )
     local satiation = targetMonster:getLogic():getMonsterData():getMonsterSatiation()
     local evolution = targetMonster:getLogic():getMonsterData():getMonsterEvolution()

     print("satiation  :"..satiation.."evolution :"..evolution)
 
     monster:getLogic():addSatiation(satiation)
     monster:getLogic():addEvolution(evolution)
     print(" targetMonster:getLogic():getMonsterData():getIsMainMonster() ")
     if targetMonster:getLogic():getMonsterData():getIsMainMonster() == false then 
        print("targetMonster:removeMonster()")
        targetMonster:removeMonster()
     end
     --如果是主角吃的，则添加流动技能
     if monster:getLogic():getMonsterData():getIsMainMonster() == true then 
        local newSkillID = targetMonster:getLogic():getMonsterData():getMonsterExclusiveSkillID()
        monster:getLogic():createFlowSkill(newSkillID)
     end
     
     if callBack ~= nil then 
        callBack()
     end
end

--吞噬失败
function CommonSkillLogic:devourMonsterFail( monster,targetMonster,callBack )
  -- body

     if callBack ~= nil then 
        callBack()
     end
end

------------------------------------------------发射类的技能公用逻辑-------------------------------------------
--生成技能子弹，
function CommonSkillLogic:createBullet( skillID )

    local bullet = mtSkillViewMgr():createSkill(skillID)
    self.parentScene:getMap():addChild(bullet,10)

    local initPos = cc.p(0,0)
    
    bullet:setPosition(initPos)

    return bullet
end

--根据 子弹 及目标点 触发移动过程 并接收事件回调
function CommonSkillLogic:shootBullet( bullet,targetPos,callBack )
    if bullet and targetPos then 
        -- 到达终点之后的回调 
        -- 自然消除
        local func = function ( )
           
        end
        
        -- 每一步的回调，检测是否触发事件
        -- 碰撞（其实就是坐标判断）时触发
        local funcStep = function ( )
           if callBack then 
              callBack()
           end
        end
        
        --向某个坐标发射  
        --
        bullet:moveToward(targetPos,func,funcStep)

    end
end


return CommonSkillLogic
