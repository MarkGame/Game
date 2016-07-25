--[[
@file   ConfigFileHelper.lua
@author vic
@date   2014-06-19
@brief  配置文件读取
--]]

local cjson = require "cjson"

--@brief    通过json文件创建 lua table
--@param    json文件名
--@return   lua table对象
function createJsonObj(file)

    if string.sub(file, -5) ~= ".json" then
        logError("createJsonObj(", file, ")  error type");
        return;
    end

    -- 读取文件
    local jsonData = cc.FileUtils:getInstance():getStringFromFile(file);
    if jsonData == nil then
        logError("createJsonObj(", file, ")  error content");
        return;
    end
    --logDebug("##createJsonObj(", file, " ) Len: " .. string.len(jsonData));
    
    local jsonObj = cjson.decode(jsonData);
    if jsonObj == nil then
        local strMessage = "解析JSON:"..file.."错误";
        --g_FloatMsg:showMsg(strMessage);
        --logDebug("##createJsonObj" .. strMessage);
    end
    
    return jsonObj;
end


function createJsonObjFromBin(file)

    if string.sub(file, -5) ~= ".json" then
        logError("createJsonObj(", file, ")  error type");
        return;
    end
    
    --local binFile = string.gsub(file, '.json', '.bin');
    --local helper = csp.CProtocolHelper:getInstance();
    -- local jsonData2 = helper:getStringFromEncryptJson(binFile);
    -- if jsonData2 == nil then
    --     logError("createJsonObjFromBin(", file, ")  error content");
    --     return;
    -- end
    --logDebug("##createJsonObjFromBin(", file, " ) Len: " .. string.len(jsonData2));
    
    local jsonObj = cjson.decode(jsonData2);
    if jsonObj == nil then
        local strMessage = "解析BinJSON:"..file.."错误";
        --logDebug("##createJsonObjFromBin" .. strMessage);
    end

    return jsonObj;
end