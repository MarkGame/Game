--[[
@file   ConfigManager.lua
@author zone
@date   2014-08-20
@brief  全局配置管理
--]]

require "ConfigFileHelper"
require "GameConfig"
------------------------------------------------

ConfigManager = class("ConfigManager");
ConfigManager.__index = ConfigManager;

-- 模块列表
ConfigManager._configs = {};--Dictionary.create();


function ConfigManager:ctor(  )
    self:init();
end

-- 单例模式
function ConfigManager:getInstance()
    if self.instance == nil then
        self.instance = ConfigManager.new();
    end
    return self.instance;
end

function ConfigManager:init()
    self._configs = {};
    for i,v in pairs(GameConfig.addConfig) do
        self:addConfig(v)
    end
    for i,v in ipairs(GameConfig.indexConfig) do
        self:createIndex(v.file,v.key)
    end
end    

function ConfigManager:initEnv(  )
    
end

--@brief    获得配置
--@param    file   配置文件
--          ID     唯一标识符
--@return   配置记录,包含list字段
function ConfigManager:getConfig(file)
    return self._configs[file];
end




--@brief    获取配置表
--@param    file   配置文件
--          file   唯一标识符
--@return   配置记录
function ConfigManager:getConfigData(file)
    return self._configs[file].list;
end


local mt = {__index = function(t,k)
        if t.defaultKey ~= nil then
            local v = t.defaultKey[k]
            if v == 1 then
                return ""
            elseif v == 2 then
                return 0
            else
                return nil
            end
        end
    end}

--@brief    加载配置
--@param    file   配置文件
--@return   NULL
function ConfigManager:addConfig(file)
    local cfg = self._configs[file];

    -- 没有加载
    if cfg == nil then
        local data = nil;
        if true == cc.FileUtils:getInstance():isFileExist(file) then
            data = createJsonObj(file); --如果存在明文配置，则优先加载
        else
            data = createJsonObjFromBin(file); --如果不存在明文配置，则加载加密配置
        end

        if data ~= nil then
            for i,v in ipairs(data.list) do
                v.defaultKey = data.defaultKey or {}
                
                setmetatable(v, mt)
            end
        end

        self._configs[file] = data;

    --logInfo("addConfig file:", file, "  OK...");
    else
    -- logWarn("addConfig file:", file, "  failed,  this file has be loaded");
    end
end

--对某张表的字段建立索引
function ConfigManager:createIndex( file,key )
    local configFile = self._configs[file];
    if configFile == nil then
        return nil;
    end
    configFile.indexTable = configFile.indexTable or {};
    local valueTable = configFile.indexTable[key];
    if valueTable == nil then
        valueTable = {}
        configFile.indexTable[key] = valueTable;
    end

    for k, v in pairs(configFile.list) do
        local index = v[key];
        if index == nil then
            local strMessage = file.."创建索引:"..key.."错误"
            --g_FloatMsg:showMsg(strMessage);
            return;
        end
        local jsonTable = valueTable[index];
        if jsonTable == nil then
            jsonTable = {};
            valueTable[index] = jsonTable;
        end
        jsonTable[#jsonTable + 1] = v;
    end
end


--@brief    获取配置 --针对有ID的JSON文件
--@param    cfg     配置对象
--          ID      配置ID
--@return   配置记录
function ConfigManager:getConfigById(cfg, ID)
    if cfg == nil then
        return nil;
    end
    local configFile = self._configs[cfg];
    if configFile == nil then
        return nil;
    end
    if configFile.indexTable and configFile.indexTable[ID] then
        return configFile.indexTable["ID"][ID];
    end
    for k, v in pairs(configFile.list) do
        if v.ID == ID then
            return v;
        end
    end
    return nil;
end




--@brief    根据某个字段值获取某个配置表
--@param    config:配置文件名,key:字段,value:值
--@return   配置记录
function ConfigManager:getData( config,key,value)
    local configFile = self._configs[config];
    if configFile == nil then
        local strMessage = "文件:"..config.."不存在"
        --g_FloatMsg:showMsg(strMessage);
        return nil;
    end
    if configFile.indexTable and configFile.indexTable[key] then
        return configFile.indexTable[key][value];
    end

    local results = {};
    for k,v in pairs(configFile.list) do
        if v[key] == value then
            results[#results + 1] = v;
        end
    end
    if #results == 0 then
        return nil;
    end
    return results;
end

--获取某张表的某个字段对应的条目数
function ConfigManager:getDataLen( config,key )
    local list = self:getDataList(config,key);
    return #list;
end

--@brief    根据某个字段值获取某个配置表,支持多字段查询
--@param    config:配置文件名,key_set{ {key = "",value = ""} }
--@return   配置记录
function ConfigManager:getData2( config,key_set,index,result)

    if index == nil then
        index = 1;
    end

    if result == nil then
        local key = key_set[index].key;
        local value = key_set[index].value
        result = self:getData(config,key,value);
        if result then
            return self:getData2( config,key_set,index + 1,result);
        else
            return nil ;
        end
    else
        if key_set[index] == nil then
            return result;
        else
            local key = key_set[index].key;
            local value = key_set[index].value;
            local data = {};
            for i,v in ipairs(result) do
                if v[key] == value then
                    data[#data + 1] = v;
                end
            end
            if #data == 0 then
                return nil;
            else
                return self:getData2( config,key_set,index + 1,data);
            end
        end
    end

end

--获取某张表某个字段的最大值
function ConfigManager:getMaxValue( config,key )
    local configFile = self._configs[config];
    if configFile == nil then
        return nil;
    end
    local maxValue = 0;
    for k,v in pairs(configFile.list) do
        if v[key] > maxValue then
            maxValue = v[key];
        end
    end
    return maxValue;
end


--获取某值的地板,二分查找
function ConfigManager:getFloor( config,key,value )
    local configFile = self._configs[config];
    if configFile == nil then
        return nil;
    end

    local index = nil;
    for k,v in pairs(configFile.list) do
        if v[key] > value then
            break;
        end
        index = v;
    end
    return index;
end

--获取某一字段对应的一组值 --long
function ConfigManager:getDataList(config, key)
    local configFile = self._configs[config];
    if configFile == nil then
        return nil;
    end
    local dataList = {};
    for k,v in pairs(configFile.list) do
        dataList[#dataList + 1] = v[key];
    end
    return dataList;
end