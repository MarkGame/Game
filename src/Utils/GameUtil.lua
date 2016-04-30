--
-- Author: HLZ
-- Date: 2016-01-08 10:47:53
-- 屏幕大小的数据 以及获得X Y比例

GameUtil = GameUtil or {}
GameUtil.WIDTH = 0
GameUtil.HEIGHT = 0


function GameUtil:VISIBLE_WIDTH()
    if GameUtil.WIDTH == 0 then
       GameUtil.WIDTH = cc.Director:getInstance():getVisibleSize().width
    end
    return GameUtil.WIDTH
end

function GameUtil:VISIBLE_HEIGHT()
    if GameUtil.HEIGHT == 0 then
       GameUtil.HEIGHT = cc.Director:getInstance():getVisibleSize().height
    end
    return GameUtil.HEIGHT
end

function GameUtil:GetScaleY(sprite)
    local height = sprite:getContentSize().height
    local scaleRate = GameUtil:VISIBLE_HEIGHT() / height 
    if scaleRate < 1 then
        return 1
    else
        return scaleRate
    end
end

function GameUtil:GetScaleX(sprite)
    local width = sprite:getContentSize().width
    local scaleRate = GameUtil:VISIBLE_WIDTH() / width
    if scaleRate < 1 then
        return 1
    else
        return scaleRate
    end
end