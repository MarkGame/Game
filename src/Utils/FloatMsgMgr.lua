--[[
@file   FloatMsgMgr.lua
@author zln
@date   2014-08-9
@brief  飘字类

--2016/8/31 HLZ 进行改写
--]]


local FloatMsgMgr = class("FloatMsgMgr",function ( )
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

-- text:文本
-- delay 持续时间
-- fontSize 字体大小
function FloatMsgMgr:showTips( text,delay,fontSize)

	if delay == nil then
	   delay = 1 
	end

	if fontSize == nil then 
	   fontSize = 26
	end
   
    local bg = ccui.ImageView:create("publish/resource/login_font_base.png");
    --设置九宫的四个属性
	bg:setCapInsets(cc.rect(20,20,20,20));
	bg:setScale9Enabled(true);
	bg:setContentSize(cc.size(300,100))

	local fnt = mtFntNormal().create(text,fontSize)
	bg:addChild(fnt)
	bg:setContentSize(cc.size(fnt:getContentSize().width + 20,fnt:getContentSize().height + 20));
	bg:setCascadeOpacityEnabled(true)
	fnt:setPosition(cc.p(bg:getContentSize().width * 0.5,bg:getContentSize().height * 0.5 + 2));
	local seq = cc.Sequence:create(cc.DelayTime:create(delay),cc.FadeOut:create(0.5),cc.CallFunc:create(function (  )
		if bg then
			bg:removeFromParent();
		end
	end))
	bg:runAction(seq);

    local size = cc.Director:getInstance():getVisibleSize()
	bg:setPosition(cc.p(size.width/2,size.height/2))

	cc.Director:getInstance():getRunningScene():getChildByTag(UI_LAYER_TAG):addChild(bg,ZVALUE_TIPS)

end

function FloatMsgMgr:showMsg2( text ,delay)

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

return FloatMsgMgr