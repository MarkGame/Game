--
-- Author: HLZ
-- Date: 2016-04-24 15:33:31
-- 孵化场的通用逻辑
-- 

local CommonHatcheryLogic = class("CommonHatcheryLogic")

function CommonHatcheryLogic:ctor(data)
   
   self.parentScene = data.parent
   self.initPos = data.initPos

   self.monsterCount = 0

end

function CommonHatcheryLogic:getParentScene( )
	return self.parentScene
end

function CommonHatcheryLogic:getInitPos( )
	return self.initPos
end


function CommonHatcheryLogic:refreshMonster( )
    -- body
    if self.updateRefreshMonster ~= nil  then
        g_scheduler:unscheduleScriptEntry(self.updateRefreshMonster);
        self.updateRefreshMonster = nil 
    end
    self.monsterCount = 1
    self.updateRefreshMonster = g_scheduler:scheduleScriptFunc(handler(self,self.addMonster),1,false)
end

function CommonHatcheryLogic:addMonster(  )
    if self.monsterCount <= 3 then 
        local monsterID = math.random(1001,1024)
        monsterID = math.random(1001,1024)
        monsterID = math.random(1001,1024)
        monsterID = math.random(1001,1024)

        local data = {}
        data.parent = self.parentScene
        data.monsterID = monsterID
        local monster = mtMonsterMgr():createMonster(data)
        self.parentScene:getMap():addChild(monster,10) 

        mtBattleMgr():addMonsterToList(monster)
        
        --初始位置
        
        local initPos = self.parentScene:positionForTileCoord(cc.p(self.initPos.x,self.initPos.y))
        monster:setPosition(initPos)
        local function func( )
            local nowTiledPos = self.parentScene:tileCoordForPosition(cc.p(monster:getPosition()))
            if nowTiledPos.x == 25 and nowTiledPos.y == 5 then 
               monster:moveToward(cc.p(6,17),func) 
            elseif nowTiledPos.x == 6 and nowTiledPos.y == 17 then 
               monster:moveToward(cc.p(7,2),func) 
            elseif nowTiledPos.x == 7 and nowTiledPos.y == 2 then 
               monster:moveToward(cc.p(24,20),func)
            elseif nowTiledPos.x == 24 and nowTiledPos.y == 20 then 
               monster:moveToward(cc.p(3,11),func)  
            elseif nowTiledPos.x == 3 and nowTiledPos.y == 11 then 
               monster:moveToward(cc.p(25,5),func) 
            end
        end

        monster:moveToward(cc.p(25,5),func)
        self.monsterCount = self.monsterCount + 1
    else
        if self.updateRefreshMonster ~= nil  then
           g_scheduler:unscheduleScriptEntry(self.updateRefreshMonster);
           self.updateRefreshMonster = nil 
        end
    end
end

function CommonHatcheryLogic:stopRefreshMonster( )
    if self.updateRefreshMonster ~= nil  then
       g_scheduler:unscheduleScriptEntry(self.updateRefreshMonster);
       self.updateRefreshMonster = nil 
    end
end


function CommonHatcheryLogic:clean( )
 
end
return CommonHatcheryLogic