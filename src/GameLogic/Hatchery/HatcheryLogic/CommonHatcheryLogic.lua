--
-- Author: HLZ
-- Date: 2016-04-24 15:33:31
-- 孵化场的通用逻辑
-- 

local CommonHatcheryLogic = class("CommonHatcheryLogic")

function CommonHatcheryLogic:ctor(data)
   
   self.parentScene = mtBattleMgr():getScene()

   self.initPos = data.initPos

   self.monsterCount = 0
   
   --是否正在孵化
   self.isHatching = false
   
end

function CommonHatcheryLogic:getInitPos( )
	return self.initPos
end


--初始化 孵化场信息
function CommonHatcheryLogic:initHatcheryInfo( )
    self.hatcheryData = mtHatcheryBaseInfo().new()
end

function CommonHatcheryLogic:getHatcheryData( )
    return self.hatcheryData
end
--------------------------------------孵化场心脏------------------------------

--[[

    由battleMgr来控制怪兽的生产

    --首先决定 生产什么样的怪兽，然后根据怪兽的孵化时间，进行一个倒计时
    --孵化的过程中 添加 变异几率（？？脑洞想的）

]]
function CommonHatcheryLogic:updateHatcheryHeart()
    
    --此时可以孵化
    if self.isHatching == false then 
        local monsterID = self:getSelectedMonsterID()
        self:addMonster(monsterID)
    end
end

--[[
    1、当前的阶段  init level1 level2 level3 出现的怪兽组也会跟着改变
    2、刷新时间间隔  
    3、场景内的怪兽数量控制在一定范围内

    新添加一个 怪兽权值表 根据概率来生成怪兽
    
    返回选择后的怪兽ID，如果返回的是空，则说明当前不需要生产怪兽（一般是 怪兽满了）
]]
function CommonHatcheryLogic:getSelectedMonsterID( )
    local randomMonsterList,totalProb = self.hatcheryData:getRandomMonsterListByStage(mtBattleMgr():getBattleStage())

    local monsterID = 0
    for i = 1 , 5 do 
        local tempInfo = {}
        local randomNum = math.random(1,totalProb)
        randomNum = math.random(1,totalProb)
        randomNum = math.random(1,totalProb)
        randomNum = math.random(1,totalProb)
        randomNum = math.random(1,totalProb)

        for k,v in ipairs(randomMonsterList) do
           if v and v.minNum <= randomNum and randomNum <= v.maxNum then 
              tempInfo = v
              break
           end
        end
        
        --限制了怪兽的孵出总数量
        if tempInfo.MaxCount > 0 then 
           --在 BattleMgr 中查找 该怪兽生成的数量，如果大于等于 tempInfo.MaxCount，则继续循环，查找
            if mtBattleMgr():getMonsterMaxCountByID(tempInfo.MonsterID) < tempInfo.MaxCount then 
               monsterID = tempInfo.MonsterID
               break
            else
               --继续循环一次，重新随机
            end
        else
            monsterID = tempInfo.MonsterID
            break
        end
    end
    
    --如果五次随机都GG了，只能默认用个 低级怪兽孵化了
    if monsterID == 0 then 
       monsterID = 1001
    end

    return monsterID
end

--满足条件才增加怪兽
function CommonHatcheryLogic:addMonster(monsterID)

    local data = {}
    data.monsterID = monsterID
    local monster = mtMonsterMgr():createMonster(data)
    self.parentScene:getMap():addChild(monster,10) 
    --2016年5月3日17:33:31的我：看一看 这里加载进的是不是 self.map
    --2016年5月4日00:04:30的我：是的，这里没问题
    mtBattleMgr():addMonsterToList(monster)
    --初始位置
    --2016年5月3日17:33:55的我：这里要看看 坐标是否正确
    local initPos = self.parentScene:positionForTileCoord(cc.p(self.initPos.x,self.initPos.y))
    monster:setPosition(initPos)

    self.isHatching = true 

end

function CommonHatcheryLogic:stopRefreshMonster( )

end


function CommonHatcheryLogic:clean( )
 
end
return CommonHatcheryLogic