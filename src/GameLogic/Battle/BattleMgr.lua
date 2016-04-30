--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 战斗场景信息管理器

--[[
    需要处理 当前进化阶段 
    整个 游戏本体流程的大主管

]]

--local SkillDetect = require("GameLogic.Skill.SkillDetect")

local BattleMgr = class("BattleMgr")
--BattleMgr.__index = BattleMgr

function BattleMgr:getInstance(  )
    if self.instance == nil then
        self.instance = BattleMgr.new()
    end
    return self.instance
end

function BattleMgr:ctor()
  --游戏开始的时候初始化 数据  
  self:initData()

end

--初始化 数据 
function BattleMgr:initData( )
  	--当前的阶段
  	self.nowStage = BattleStage.init

    --当前存活的怪兽表
    --包含 主怪 中立怪 敌方怪
    self.monsterList = {}

end
--设置我的怪兽
--玩家自身
function BattleMgr:setMyMonster(player)
    self.player = player
end

--添加怪兽进入列表
--[[
    会存在 怪兽ID相同的怪兽 所以 不能以 怪兽ID 做index 
    希望 以后可以通过 怪兽生成的时间 做区分
    存进来的是 怪兽的实例
]]
function BattleMgr:addMonsterToList(monster)
	  if monster then 
     table.insert(self.monsterList,monster)
	  end
end

--[[
    从当前存活的怪兽表中剔除
]]
function BattleMgr:removeMonsterFromList(monster)
  	if monster then 
         for k,v in ipairs(self.monsterList) do
         	   if v and v == monster then 
                table.remove(self.monsterList,k)
                break
         	   end
         end
  	end
end

--根据 initPos skillRangeType 来获得 在当前在探测范围内的坐标点数组
function BattleMgr:detectMonster(initPos,skillRangeInfo)
    
    --要区分。。怪物自身 不能放进去  2016年4月29日02:30:53 明天再弄吧
    local targetPosList = mtSkillDetect():getSkillDetectPosList(initPos,skillRangeInfo)

    local targetMonsterList = {}

    --递归查找 是否有满足 在范围坐标点数组内的怪兽
    if self.monsterList and #self.monsterList > 0 then 
        for k,v in ipairs(self.monsterList) do
           if v then 
              local monsterPos = v:getTiledMapPos()
              
              for kk,vv in ipairs(targetPosList) do
                  --当前坐标 和 存活的怪物有相同的 则 存放在 范围内怪兽数组里
                  if vv and vv.x == monsterPos.x and vv.y == monsterPos.y then 
                     table.insert(targetMonsterList,v)
                  end

              end
           end
        end
    end

    return targetMonsterList
end

--获得离自己最近的一个怪兽
--因为有障碍物 所以不能直接比较距离
--这里有问题 直接在 搜寻的时候 由近来查找 就可以了 那么第一个就是最近的
function BattleMgr:getNearestMonster( monsterList,monster )

    -- if monster == nil then 
    --    monster = self.player
    -- end
    -- local initPos = monster:getTiledMapPos()
    -- local nearestDistance = 99999
    
    -- if monsterList and #monsterList > 0 then 
    --    for k,v in ipairs(monsterList) do
    --        if v then 
    --           local targetPos = v:getTiledMapPos()
              
    --        end
    --    end
    -- else 

    -- end
end


return BattleMgr
