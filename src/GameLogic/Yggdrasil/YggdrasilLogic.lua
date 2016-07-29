--
-- Author: HLZ
-- Date: 2016-04-28 11:52:31
-- 世界树的通用逻辑
-- 
--[[

]]

local YggdrasilLogic = class("YggdrasilLogic")

function YggdrasilLogic:ctor(data)
    self.isBearFruit = false
end

function YggdrasilLogic:getInitPos()
	return cc.p(0,0)
end

--初始化 孵化场信息
function YggdrasilLogic:initYggdrasilInfo( )
    self.yggdrasilData = mtYggdrasilBaseInfo().new()
end

function YggdrasilLogic:getYggdrasilData( )
    return self.yggdrasilData
end

function YggdrasilLogic:getResidualTime(  )
    return self.residualTime
end
--------------------------------------世界树 心脏------------------------------

--[[
]]
function YggdrasilLogic:updateYggdrasilHeart()
    if self:isCanBearFruit() == true and self.isBearFruit == false then 
        self.isBearFruit = true
        self.fruitID = self:getSelectedYggdrasilID()
    end
end

function YggdrasilLogic:getSelectedYggdrasilID( )
    local randomMonsterList,totalProb = self.hatcheryData:getRandomMonsterListByStage(mtBattleMgr():getBattleStage())

    local fruitID = 0
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
        if tempInfo.maxCount > 0 then 
           --在 BattleMgr 中查找 该怪兽生成的数量，如果大于等于 tempInfo.maxCount，则继续循环，查找
            if mtBattleMgr():getMonsterMaxCountByID(tempInfo.monsterID) < tempInfo.maxCount then 
               monsterID = tempInfo.monsterID
               break
            else
               --继续循环一次，重新随机
            end
        else
            fruitID = tempInfo.monsterID or 0 
            break
        end
    end
    
    --如果五次随机都GG了，只能默认用个 低级怪兽孵化了
    if fruitID == 0 then 
       fruitID = 1001
    end

    return fruitID
end

--满足条件才增加
function YggdrasilLogic:addFruit(fruitID)
    
    if fruitID == nil then
       fruitID = self.fruitID 
    end

    local data = {}
    data.fruitID = fruitID

    -- local monster = mtMonsterMgr():createMonster(data)
    -- self.parentScene:getMap():addChild(monster,10)
    -- mtBattleMgr():addMonsterToList(monster)

    -- local initPos = self:getRandomPos()
    
    -- monster:setPosition(initPos)
    
end

--随机初始点
function YggdrasilLogic:getRandomPos( )

    --最多执行五次,否则就使用默认坐标
    local pos = cc.p(0,0)
  
    for i = 1 , 5 do 
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
           pos = self.parentScene:positionForTileCoord(target)
           break
        end
    end

    if pos == cc.p(0,0) then 
       pos = self.parentScene:positionForTileCoord(cc.p(self.initPos.x,self.initPos.y))
    end

    return pos
end


--清理
function YggdrasilLogic:clean( )
 
end

--判断当前符合条件
function YggdrasilLogic:isCanBearFruit( )
    return true
end

return YggdrasilLogic