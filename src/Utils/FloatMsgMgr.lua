--[[
@file   FloatMsgMgr.lua
@author zln
@date   2014-08-9
@brief  飘字类

--2016/8/31 HLZ 进行改写
--]]


FloatMsgMgr = class("FloatMsgMgr",function ( )
	return cc.Node:create();
end);

FloatMsgMgr.__index = FloatMsgMgr;

FloatMsgMgr._queueText = nil; --飘字队列

FloatMsgMgr._customData = nil;

function FloatMsgMgr:getInstance()
	if self.instance == nil then
		self.instance = FloatMsgMgr.new();
	end
	return self.instance;
end

function FloatMsgMgr:ctor( )
	self._queueText = {};
	self:retain();
	self:setName(self.__cname)
end


function FloatMsgMgr:showTips( text,delay )
	-- body
end

function FloatMsgMgr:showMsg2( text ,delay)
	if text == nil then
		return ;
	end
	if fntSize == nil then 
		fntSize = 36;
	end
	if delay == nil then
		delay = 1;
	end
	 
	local color = cc.c3b(254,231,44)

	local label = FntNormal.create(text,26,ig.WHITE)--cc.LabelTTF:create(text, "Marker Felt", fntSize);
	label:setColor(color);
	g_scene:addChild(label);
	local winSize = cc.Director:getInstance():getVisibleSize();
	local idx = self:_findSpare();
	label:setPosition(cc.p(winSize.width * 0.5,winSize.height * 0.5 + (idx - 1) * label:getContentSize().height + 28));
	local move = cc.MoveBy:create(0.5,cc.p(0,150));
	local fade = cc.FadeOut:create(0.5);
	local spawn = cc.Spawn:create(move,fade);
	local function moveOver( )
		label:removeFromParent();
		self:_setSpare(idx,nil);
	end
	local scale = cc.ScaleTo:create(0.1,0.8)
	local scale2 = cc.ScaleTo:create(0.1,1.0)
	label:setScale(4)
	label:setOpacity(0)
	label:runAction(cc.FadeIn:create(0.2))
	local seq = cc.Sequence:create(scale,scale2,cc.DelayTime:create(delay),spawn,cc.CallFunc:create(moveOver));
	label:runAction(seq);
    self:_setSpare(idx,label);
end


--查找并返回一个空的位置
function FloatMsgMgr:_findSpare()
	local idx = 1;
	while true do
		if self._queueText[idx] == nil then
			break;
		end
		idx = idx + 1;
	end
	return idx;
end

--设置一个位置可以用
function FloatMsgMgr:_setSpare(idx ,label)
	self._queueText[idx] = label;
end