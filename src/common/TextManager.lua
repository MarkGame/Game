

-----------------------------------------------------------------------------------------------------------------
local TextManager = {};

--OutlineType
TextManager.OUTLINE_NONE = 0
TextManager.OUTLINE_CUSTEM = 1 -- 自定义描边大小颜色
TextManager.OUTLINE_DARK = 2 --深色底的文字用深色描边
TextManager.OUTLINE_SMALLDARK = 3 --深色1像素描边
TextManager.OUTLINE_LIGHT = 4 --深色底的文字用浅色描边
TextManager.OUTLINE_LARGER = 5 --大字体的粗描边
TextManager.OUTLINE_TITLE = 6 --大标题的粗描边
TextManager.OUTLINE_BUTTON = 7 --绿色按钮的描边


function TextManager:getText( strid )
    -- 如果传进来的是个表。直接返回空字符串
    if strid == nil or type(strid) == "table" then
        return "";
    else
        local strText = Table[strid] or strid;
        -- 如果Table取出来不是字符串或者数字的话返回原来传进来的字符串
        if type(strText)=="number" or type(strText)=="string" then
        else
            strText = strid;
        end

        return strText;
    end
end

function TextManager:setStringID( uiWidget, strid, bTitle, bOutline, outlineColor, outlineSize, bSystem)
    local strContent = self:getText(strid);
    if strContent ~= nil then
        self:setString(uiWidget, strContent, bTitle, bOutline, outlineColor, outlineSize, bSystem);
    end
end

--当bOutline为TextManager.OUTLINE_CUSTEM时自定位套边
function TextManager:setString( uiWidget, strContent, bTitle, bOutline, outlineColor, outlineSize, bSystem )
    local fontName = "";
    local strText = strContent or "";
--    bTitle = bTitle or false;
--    if bTitle then
--        strText = string.upper(strText);
--    end

    fontName = self:getFontName();
    if fontName == "" then
        bSystem = true
    end
    if strText ~= nil then
        if false == global:isNodeValid( uiWidget ) then
            return;
        end
       -- Mlog:debug(strText .. tostring(bSystem))
        local desc = uiWidget:getDescription();
        if desc ~= nil then
            local label;
            local fontSize;
            local ttfConfig = {};
            if desc == "Label" or desc == "TextAtlas" or desc == "TextBMFont" then
                label = uiWidget:getVirtualRenderer();
                ttfConfig = label:getTTFConfig() or ttfConfig;
                ttfConfig.fontSize = uiWidget:getFontSize();
                fontSize = uiWidget:getFontSize();
            elseif desc == "Button" then
                label = uiWidget:getButtonTextLabel();
                ttfConfig = label:getTTFConfig() or ttfConfig;
                ttfConfig.fontSize = uiWidget:getTitleFontSize();
                fontSize = uiWidget:getTitleFontSize();
            elseif  desc == "TextField"  then
                label = uiWidget:getVirtualRenderer();
                tolua.cast(label,"cc.Label");
                ttfConfig = label:getTTFConfig() or ttfConfig;
                ttfConfig.fontSize = uiWidget:getFontSize();
                fontSize = uiWidget:getFontSize();
            end
            -- 是否是系统字体
            if bSystem then
                label:setSystemFontName("")
                if BaseRequires.LANGUAGE_SETTING == BaseRequires.LanguageTable.HANWEN then
                    --韩文缩小2号
                    fontSize = fontSize - 2;
                end
                label:setSystemFontSize(fontSize)
            else
	            ttfConfig.fontFilePath = fontName;
                label:setTTFConfig(ttfConfig);
            end

            if desc == "Label" or desc == "TextAtlas" or desc == "TextBMFont" then
                uiWidget:setString(strText);
            elseif desc == "TextField" then
                uiWidget:setPlaceHolder(strText);
            elseif desc == "Button" then
                uiWidget:setTitleText(strText);
                if (label:getContentSize().width + 5) > uiWidget:getContentSize().width then
                    -- 文字如果超框，则自动加大按钮背景宽度
                    -- local scale = uiWidget:getContentSize().width/(label:getContentSize().width + 20)
                    -- uiWidget:setContentSize(cc.size(label:getContentSize().width + 20, uiWidget:getContentSize().height))
                end
            end
            --Mlog:debug(label:getSystemFontSize().."   "..label:getContentSize().height.."  "..uiWidget:getContentSize().height.." "..label:getHeight().." "..strText)
            local labelHeight = label:getContentSize().height
            if bSystem and label:getSystemFontSize() * 1.2 > uiWidget:getContentSize().height then
                uiWidget:setContentSize(cc.size(uiWidget:getContentSize().width, label:getSystemFontSize()*1.2))
            end
            if BaseRequires.LANGUAGE_SETTING == BaseRequires.LanguageTable.ARABIC and label:getContentSize().height > label:getSystemFontSize()*2 and label:getHorizontalAlignment() == cc.TEXT_ALIGNMENT_LEFT then
                label:setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT) -- 阿拉伯语右对齐
            end
            if bOutline ~= nil and bOutline ~= false then
                local color = cc.c4b(116,66,4,255)
                local size = 2
                if(bOutline == TextManager.OUTLINE_CUSTEM) then
                    color = outlineColor or cc.c4b(116,66,4,255);
                    size = outlineSize or 1;
                elseif bOutline == TextManager.OUTLINE_DARK then
                    color = cc.c4b(112,65,37,255);
                    size = 2;
                elseif bOutline == TextManager.OUTLINE_SMALLDARK then
                    color = cc.c4b(112,65,37,255);
                    size = 1;
                elseif bOutline == TextManager.OUTLINE_LIGHT then
                    color = cc.c4b(173,121,82,255);
                    size = 2;
                elseif bOutline == TextManager.OUTLINE_LARGER then
                    color = cc.c4b(149,62,5,255);
                    size = 3;
                elseif bOutline == TextManager.OUTLINE_TITLE then
                    color = cc.c4b(34,55,84,255);
                    size = 2;
                elseif bOutline == TextManager.OUTLINE_BUTTON then
                    color = cc.c4b(64,112,18,255);
                    size = 2;
                else
                    color = outlineColor or cc.c4b(116,66,4,255);
                    size = outlineSize or 1;
                end
                label:enableOutline(color, size);
                if bSystem ~= true then
                    label:setAdditionalKerning(-1 - size);
                end
            end
        end
    end
end

function TextManager:setSystemString( uiWidget, strContent, outlineType )
   self:setString( uiWidget, strContent, false, outlineType, nil, nil, true )
end

function TextManager:getFontName()
    if self.m_fontName == nil then
        local sFontPath = "fonts/DroidSans.ttf"
        --if language and language.sFontPath ~= "" then
        if sFontPath ~= ""then 
            if self:isFontExist(sFontPath) then
                self.m_fontName = sFontPath
            else
                self.m_fontName = ""
                self.m_bSystemFont = true
            end
        else
            self.m_fontName = ""
            self.m_bSystemFont = true
        end
    end
    return self.m_fontName
end

function TextManager:isFontExist(sFontPath)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform();
    if string.find(sFontPath, "/system/fonts") then
        self.m_bSystemFont = true
        return true
    elseif cc.FileUtils:getInstance():isFileExist(sFontPath) then
        return true
    end
    return false
end

function TextManager:createLabel(text, fontSize, alignment, color, contentSize)
    if alignment == nil then
        alignment = cc.TEXT_ALIGNMENT_CENTER;
    end
    local fontName = self:getFontName();
    local label = nil;
    --Mlog:debug('---------------self.m_bSystemFont:'..tostring(self.m_bSystemFont))
    if self.m_bSystemFont == true then
        label = cc.Label:createWithSystemFont(text, fontName, fontSize, contentSize or cc.size(0,0), alignment);
    else
        local ttfConfig = {};
        ttfConfig.fontFilePath = fontName;
	    ttfConfig.fontSize = fontSize;
        ttfConfig.glyphs = cc.GLYPHCOLLECTION_DYNAMIC;
        ttfConfig.customGlyphs = nil;
        ttfConfig.distanceFieldEnabled = false;
        ttfConfig.outlineSize = 0;
        local maxLineWith = contentSize == nil and 0 or contentSize.width
        label = cc.Label:createWithTTF(ttfConfig, text, alignment, maxLineWith);
    end
    if color then label:setColor(color) end
    return label;
end

--动态创建ttf，比如跳数字
function TextManager:createTTF(context, xpos_pixel, ypos_pixel, layer, color, fontSize, outlineColor, outlineSize, bFlipY)
	local ttfConfig = {};
    ttfConfig.fontFilePath = mtTextManager():getFontName();
	ttfConfig.fontSize = fontSize;
    ttfConfig.glyphs = cc.GLYPHCOLLECTION_DYNAMIC;
    ttfConfig.customGlyphs = nil;
    ttfConfig.distanceFieldEnabled = false;
    ttfConfig.outlineSize = 0;

    local labelNumber = nil
    if self.m_bSystemFont ~= true then
	    labelNumber = cc.Label:createWithTTF(ttfConfig, context, cc.TEXT_ALIGNMENT_CENTER);
        if labelNumber == nil then
	        labelNumber = cc.Label:createWithTTF(ttfConfig, " ", cc.TEXT_ALIGNMENT_CENTER);
        end
    else
	    labelNumber = cc.Label:createWithSystemFont(context, mtTextManager():getFontName(), fontSize, cc.size(0,0),cc.TEXT_ALIGNMENT_CENTER);
        if not labelNumber then
            return nil
        end
    end
	local pos = cc.p(xpos_pixel, ypos_pixel);
	-- CocosPosToOriginal(pos)
    if bFlipY then
	    local size = cc.Director:getInstance():getWinSizeInPixels();
        pos.y = size.height - pos.y;
    end

	labelNumber:setPosition(pos);
	labelNumber:setColor(color);
	labelNumber:setAnchorPoint(cc.p(0.5,0.5));
    if outlineColor then
        labelNumber:enableOutline(outlineColor, outlineSize);
        if self.m_bSystemFont ~= true then
            labelNumber:setAdditionalKerning(-1 - outlineSize);
        end
    end

    labelNumber:setLocalZOrder(ZVALUE_UI);
	--AGameManager:getInstance():addGamelayerNode(labelNumber);
	if layer ~= nil then
		layer:addChild(labelNumber);
	else
        local pGameLayer = self:getGameLayer();
		pGameLayer:addChild(labelNumber);
	end

    return labelNumber;
end

function TextManager:SetAutoAdaptString(widget,str)
        mtTextManager():setString(widget, str)
        widget:getVirtualRenderer():setMaxLineWidth(widget:getContentSize().width)
        widget:getVirtualRenderer():setDimensions(widget:getContentSize().width, 0)
        --widget:getVirtualRenderer():requestSystemFontRefresh()
        widget:setTextAreaSize(widget:getVirtualRenderer():getContentSize())
end


--系统字体不支持高度自适应，待解，高版本有
--widget 得是 UiText
function TextManager:SetAutoAdaptSysString(widget,str)
	-- widget:setString("12312312asdfsadfasdfasdfasdfasd asdfasdfasdfas dasfasdfasdf asdfadsgfdg")
	-- local size = cc.size(400, 200)
	-- widget:setTextAreaSize(size)
	-- widget:ignoreContentAdaptWithSize(false)
	-- widget:setContentSize(size)
        mtTextManager():setString(widget, str, nil, nil, nil, nil, true)
        widget:getVirtualRenderer():setMaxLineWidth(widget:getContentSize().width)
        widget:getVirtualRenderer():setDimensions(widget:getContentSize().width, 0)
        widget:getVirtualRenderer():requestSystemFontRefresh()
        widget:setTextAreaSize(widget:getVirtualRenderer():getContentSize())
end


--[[
function TextManager:getGameLayer()
     local layer = cc.Director:getInstance():getRunningScene():getChildByTag( TD_GAME_LAYER_TAG );
    if layer ~= nil then
        return layer;
    else
        return mtAnimManager():getBattleWatchGameLayer();
    end
end]]

return TextManager;
