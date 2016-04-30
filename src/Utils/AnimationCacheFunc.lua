--
-- Author: HLZ
-- Date: 2016-02-17 20:07:09
-- 动画帧功能

AnimationCacheFunc = {}

local sharedTextureCache     = cc.Director:getInstance():getTextureCache()
local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
local sharedAnimationCache   = cc.AnimationCache:getInstance()
local actionManager = cc.Director:getInstance():getActionManager()

--[[
    使用动画方法顺序：
    1：加载资源
    2：将动画帧添加到序列
    3：新添加动画
    4：对新动画进行命名
    5：使用新动画
    6：删除动画
--]]


--这里添加帧数集资源
function AnimationCacheFunc.addSpriteFramesWithFile(imageFileName)
	sharedSpriteFrameCache:addSpriteFrames(imageFileName)  
end

 --这里删除帧数集资源
function AnimationCacheFunc.removeSpriteFramesFromFile(imageFileName,imageName)
	sharedSpriteFrameCache:removeSpriteFramesFromFile(imageFileName) 
	if imageName then 
		AnimationCacheFunc.removeSpriteFrameByImageName(imageName)
	end
end

--从内存删除资源图片
function AnimationCacheFunc.removeSpriteFrameByImageName(imageName)
    sharedSpriteFrameCache:removeSpriteFrameByName(imageName)
    cc.Director:getInstance():getTextureCache():removeTextureForKey(imageName)
end

-- 添加动画帧到帧序列frames内
-- pattern 图片帧名 begin 起始索引 length 长度 isReversed 是否是递减索引 
function AnimationCacheFunc.newFrames(pattern,begin,length,isReversed)
	--初始化一些变量
	--帧数组
	local frames = {}
	--默认为递增
	local step = 1 
	--最后一个元素
	local last = begin + length - 1 
   
    --如果是递减，则头尾替换，增值为-1
	if isReversed == true then 
		begin,last = last,begin 
		step = -1 
	end

	for i = begin,last,step do 
		local frameName = string.format(pattern,i)
		local frame = sharedSpriteFrameCache:getSpriteFrame(frameName)
		if frame == nil then 
		   print("frameName: "..frameName.."isError")
		   return 
		end
        
        frames[#frames + 1] = frame
	end

	return frames
end

--新添加动画
--frames 帧数集  设置两个帧播放时间  延迟 isRestoreOriginalFrame 是否动画执行后还原初始状态
function AnimationCacheFunc.newAnimation(frames, time , isRestoreOriginalFrame)
    local count = #frames
    -- local array = Array:create()
    -- for i = 1, count do
    --     array:addObject(frames[i])
    -- end
    time = time or 1.0 / count
    local anim = cc.Animation:createWithSpriteFrames(frames, time)
    if isRestoreOriginalFrame then
       anim:setRestoreOriginalFrame(isRestoreOriginalFrame)
    end
    return anim
end


-- 以指定名字缓存创建好的动画对象，以便后续反复使用
-- animation 动画对象  name 名字 

function AnimationCacheFunc.setAnimationCache(animation, name)
    sharedAnimationCache:addAnimation(animation, name)
end

-- 取得以指定名字缓存的动画对象，如果不存在则返回 nil
function AnimationCacheFunc.getAnimationCache(name)
    return sharedAnimationCache:getAnimation(name)
end

-- 删除指定名字缓存的动画对象
function AnimationCacheFunc.removeAnimationCache(name)
    sharedAnimationCache:removeAnimation(name)
end

function AnimationCacheFunc.removeUnusedSpriteFrames()
    sharedSpriteFrameCache:removeUnusedSpriteFrames()
    sharedTextureCache:removeUnusedTextures()
end

function AnimationCacheFunc.playAnimationForever(target, animation, delay)
	
	AnimationCacheFunc.stopTarget(target)

    local animate = cc.Animate:create(animation)
    target:runAction(cc.RepeatForever:create(animate))
end

function AnimationCacheFunc.stopTarget(target)
    if target ~= nil then
        actionManager:removeAllActionsFromTarget(target)
    end
end

return AnimationCacheFunc