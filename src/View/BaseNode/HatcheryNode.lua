--
-- Author: HLZ
-- Date: 2016-04-24 00:51:13
-- 孵化场节点封装

HatcheryNode = class("HatcheryNode",function ()
	return cc.Node:create()
end)

HatcheryNode.__index = HatcheryNode


--[[
    怪兽的通用的继承节点
    主要功能用：
               自动寻路

]]

function HatcheryNode:ctor()
    --进入时，调用onEnter() 
    --退出时，调用onExit()
  	self:registerScriptHandler(function ( event )
  		if event == "enter" then
  			self:onEnter()
  		elseif event == "exit" then
  			self:onExit()
  		end
  	end)

      --当前场景监听的事件数组
  	self.eventListeners = {}
    
    --动画名称列表
    self.animNameList = {}

    self:setCameraMask(2)

  	self:setName(self.__cname)

  	-- local body = cc.PhysicsBody:createBox(self:getContentSize(), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
   --    self:setPhysicsBody(body)

end

function HatcheryNode:dispatchEvent(event,data)
	   g_EventDispatch:dispatchEvent(event,data)
end


function HatcheryNode:registerEvent( event,callBack,groupID,priority )
  	--将事件加入数组，方便在退出的时候将侦听事件给移除掉
  	self.eventListeners = self.eventListeners or {}
  	self.eventListeners[#self.eventListeners + 1] = g_EventDispatch:registerEvent(event,callBack,groupID,priority)
  	return self.eventListeners[#self.eventListeners + 1]
end

function HatcheryNode:onExit( )
  	if self.eventListeners == nil then
  		return 
  	end
  	--统一对事件数组里面的时间进行释放
  	for i,v in ipairs(self.eventListeners) do
  		g_EventDispatch:removeEvent(v)
  	end	
end

function HatcheryNode:onEnter( )
	
end

function HatcheryNode:onHide(  )
	
end


function HatcheryNode:setParentScene(parent)
  	self.parentScene = parent
end

--[[
    动画规格类型  静止图 上下左右各1 行走图 上下左右各2 吞噬图 ？ 释放技能图 ？ 死亡图 ？
    这里需要对所有的 角色进行一个名称规范
    怪物表格里面 增加一列 资源名称 
    比如 骷髅怪 一列  资源名称  Skeleton_%d
                      动画名称  Skeleton_
]]
function HatcheryNode:initAnim(resName,animName)
    self.animNameList = {}

    local animationNames = {"idleD","idleL","idleR","idleU","walkD","walkL", "walkR", "walkU"}
    local animationFrameNum = {1,1,1,1,2,2,2,2}
   
    for i = 1, #animationNames do
        local str = string.format(resName,i)
        local frames = AnimationCacheFunc.newFrames(str.."_%d.png", 1, animationFrameNum[i])
        local animation = AnimationCacheFunc.newAnimation(frames, 0.2)
        local animationName = animName..animationNames[i]
        table.insert(self.animNameList,i,animationName)
        AnimationCacheFunc.setAnimationCache(animation,animationName)
    end
end

function HatcheryNode:playAnim( animType )
    AnimationCacheFunc.playAnimationForever(self.sprite, AnimationCacheFunc.getAnimationCache(self.animNameList[animType]))
end



	
