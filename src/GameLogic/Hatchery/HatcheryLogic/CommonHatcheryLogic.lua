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
   
   --当前孵化的怪兽ID
   self.monsterID = 0 
   
   --剩余时间
   self.residualTime = 0
   
   --孵化结束的时间
   self.hatchCompleteTime = 0

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

function CommonHatcheryLogic:getResidualTime(  )
    return self.residualTime
end
--------------------------------------孵化场心脏------------------------------

--[[

    由battleMgr来控制怪兽的生产

    --首先决定 生产什么样的怪兽，然后根据怪兽的孵化时间，进行一个倒计时
    --孵化的过程中 添加 变异几率（？？脑洞想的）

]]
function CommonHatcheryLogic:updateHatcheryHeart()
    --此时可以孵化
    if self.residualTime == 0 and self:isCanHatchery() == true then 
        self.monsterID = self:getSelectedMonsterID()
        self:hatchingMonster()
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
            monsterID = tempInfo.MonsterID or 0 
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
    
    if monsterID == nil then
       monsterID = self.monsterID 
    end

    local data = {}
    data.monsterID = monsterID
    local monster = mtMonsterMgr():createMonster(data)
    self.parentScene:getMap():addChild(monster,10)
    --2016年5月3日17:33:31的我：看一看 这里加载进的是不是 self.map
    --2016年5月4日00:04:30的我：是的，这里没问题
    mtBattleMgr():addMonsterToList(monster)
    --初始位置
    --2016年5月3日17:33:55的我：这里要看看 坐标是否正确
    --2016年7月5日14:43:53的我：这里怪兽生成的坐标 还是可以做点随机性的 后面写一个方法来实现
    --2016年7月5日17:32:09的我：已经写好了，getMonsterRandomPos
    local initPos = self:getMonsterRandomPos()
    monster:setPosition(initPos)
    
end

--随机孵化初始点附近的坐标作为怪兽的孵化点
function CommonHatcheryLogic:getMonsterRandomPos( )

    --最多执行五次,否则就使用默认坐标
    local count = 1
    local searchPos = function ( )
        if count <= 5 then 
            local randomX = math.random(-5,5)
            randomX = math.random(-5,5)
            randomX = math.random(-5,5)
            randomX = math.random(-5,5)
            randomX = math.random(-5,5)

            local randomY = math.random(-5,5)
            randomY = math.random(-5,5)
            randomY = math.random(-5,5)
            randomY = math.random(-5,5)
            randomY = math.random(-5,5)

            local target = cc.p(randomX+self.initPos.x,randomY+self.initPos.y)
            --判断新的坐标是否是可行点，不行则继续searchPos
            if self.parentScene:targetPosIsBarrier(target) == true then 
               return self.parentScene:positionForTileCoord(target)
            else
               count = count + 1
               searchPos()
            end
        else
            return self.parentScene:positionForTileCoord(cc.p(self.initPos.x,self.initPos.y))
        end   
    end 

    --延迟一帧 执行搜索坐标
    g_Worker:pushDelayQueue(function()
      searchPos()
    end)

end

--刷新孵化CD
function CommonHatcheryLogic:refreshHatchCD( )

    local nowTime = mtTimeMgr():getMSTime()
    --已经完成孵化CD
    if nowTime >= self.hatchCompleteTime then 
       self:addMonster()
       self.updateHatchCDHandler = mtSchedulerMgr():removeScheduler(self.updateHatchCDHandler)
       self.residualTime = 0
    else
       self.residualTime = math.max(nowTime-self.hatchCompleteTime,0) 
    end

end

--孵化怪兽
function CommonHatcheryLogic:hatchingMonster(  )
    local monsterInfo = g_Config:getData(GameConfig.addConfig["Monster"],"ID",self.monsterID)[1]
    self.residualTime = monsterInfo.HatchTime
    self.hatchCompleteTime = mtTimeMgr():getMSTime() + monsterInfo.HatchTime
    self.updateHatchCDHandler = mtSchedulerMgr():removeScheduler(self.updateHatchCDHandler)
    self.updateHatchCDHandler = mtSchedulerMgr():addScheduler(0.1,-1,handler(self,self.refreshHatchCD))
end

--清理
function CommonHatcheryLogic:clean( )
 
end

--判断当前符合孵化条件
function CommonHatcheryLogic:isCanHatchery( )
    local nowStage = mtBattleMgr():getBattleStage()
    --初始阶段 和 结束阶段是不需要 孵化怪兽的
    if nowStage == BattleStage.init or nowStage == BattleStage.ended then 
       return false
    end 

    --控制当前怪兽 当前阶段怪兽的总数
    local hatcheryInfo = self.hatcheryData:getNowHatcheryInfo(mtBattleMgr():getBattleStage())
    local monstersByLevelList,totalMonstersCounts = mtBattleMgr():getMonsterListByLevel()
    if monstersByLevelList[nowStage] ~= nil and monstersByLevelList[nowStage].count >= hatcheryInfo.MonsterTotal then 
       return false
    else
       return true
    end

end

return CommonHatcheryLogic