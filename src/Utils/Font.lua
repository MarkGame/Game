--[[
@file   Font.lua
@author zone
@date   2014-08-20
@brief  字体库

2016/9/2 HLZ 修改
--]]

local FntNormal = class("FntNormal");


function FntNormal.createLeaderLabel( str,size,isMiaoBian )
	if size == nil then
		size = 26;
	end
	local label = FntNormal.create(str,size);
	local pt = cc.p(label:getContentSize().width * 0.5 ,label:getContentSize().height * 0.5)
	local space = 1;
    if isMiaoBian ~= false then
		for i=1,4 do
		 	local labelTemp = FntNormal.create(str,size);
		 	label:addChild(labelTemp,-1)
		 	labelTemp:setColor(cc.c3b(0,0,0))
		 	if i == 1 then
		 		labelTemp:setPosition(cc.p(pt.x + space,pt.y + space));
		 	elseif i == 2 then
		 		labelTemp:setPosition(cc.p(pt.x + space,pt.y - space));
		 	elseif i == 3 then
		 		labelTemp:setPosition(cc.p(pt.x - space,pt.y - space));
		 	elseif i == 4 then
		 		labelTemp:setPosition(cc.p(pt.x - space,pt.y + space));
		 	end
		 end
	end
	return label;
end

--fntType:nil微软雅黑
function FntNormal.create(str,fntSize,fntType,area,hAlignment,vAlignment)
	local fnt = nil;
	if fntSize == nil then
		fntSize = 20;
	end
	
	local fntPath = nil --ig.FNT[fntType]
	if fntPath == nil then
		print("cc.LabelTTF:create "..str)
		fnt = cc.LabelTTF:create(str, "Microsoft Yahei",fntSize)
		
		if area then
			fnt:setDimensions(area);
		end
	else
		print("cc.Label:createWithBMFont "..str.." "..fntPath.." ")
		fnt = cc.Label:createWithBMFont(fntPath, str)
		--fnt:setSystemFontSize(fntSize)
	end
	if hAlignment then
		fnt:setHorizontalAlignment(hAlignment);
	end
	if vAlignment then
		fnt:setVerticalAlignment(vAlignment);
	end
	return fnt;
end



function FntNormal.createByPNG( content,fnt,width,height,ignoreFuHao)
	local fontStr = "";
    if type(content) == "string" then
        fontStr = content;
    else
        fontStr = tostring(content);
        if content > 0 and ignoreFuHao ~= true then
            fontStr = "+" .. fontStr
        end
    end
    fontStr = string.gsub(fontStr, "%%", ":");
    fontStr = string.gsub(fontStr, "+", ";");
    fontStr = string.gsub(fontStr, "-", "<");
    if width == nil  then
    	width = 27;
    end
    if height == nil then
    	height = 30;
    end
    local label = cc.LabelAtlas:create(fontStr, fnt, width, height, string.byte('0'));
    label:setAnchorPoint(cc.p(0.5,0.5))
    return label;
end

return FntNormal
