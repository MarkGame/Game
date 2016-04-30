
-- if BaseRequires.VersionType == 0 then
--     require "lua/common/data/clientDBTextImage_Abroad"
--     require "lua/common/data/clientDBTextLanguage_Abroad"
--     require "lua/common/data/clientDBTextEn_Abroad"

--     Table.clientDBTextLanguage = Table.clientDBTextLanguage_Abroad
--     Table.clientDBTextImage = Table.clientDBTextImage_Abroad
-- else
--     require "lua/common/data/clientDBTextImage"
--     -- require "lua/common/data/clientDBVoice"
--     require "lua/common/data/clientDBTextLanguage"
--     require "lua/common/data/clientDBTextEn"
-- end


-- if BaseRequires == nil or BaseRequires.ENABLE_CLIENT_VIEW == false then
--     --require "lua/common/data/clientDBTextEn"
-- else   
--     local language = Table.clientDBTextLanguage[BaseRequires.LANGUAGE_SETTING]
--     if language then
--         local sTextPath = language[Table.clientDBTextLanguage.switch.sTextPath]
--         if(sTextPath and cc.FileUtils:getInstance():isFileExist(getLuaPath(sTextPath)..cc.CCCrypto:getLuaExtension())) then
--             require(sTextPath)
--         else
--             --require("lua/common/data/clientDBTextEn")
--         end
--     else
--         --require("lua/common/data/clientDBTextEn")
--     end
-- end
setmetatable(Table, {
    __index = function(self, field)
        if string.sub(field, 1, 6) == 'STRID_' then
            return field;
        end
        return nil;
    end
});

-- if BaseRequires.VersionType == 0 then
-- --if true then
--     require "lua/common/data/clientDBGame_Abroad"
-- else
    require "GameLogic.Data.clientDBGame"
-- end

require "GameLogic.Data.TableParser"

function TableLoader()
    for k, v in pairs(Table) do
        if type(v) == "table" and v.switch ~= nil then

            v.mt = {}
            v.mt.__index = function (self, field)
                local index = v.switch[field]
                if index == nil then
                    return nil
                end

                self[field] = self[index]

                if self[index] == nil then --[CY ADD: 防止进入无限循环查找]
                    return nil;
                end

                return self[field]
            end

            v.get = function(...)
                local arg = {...}
                if #arg == 0 then
                    return
                end

                -- splice key
                local key
                if #arg == 1 then
                    key = arg[1] 
                    if type(key) == "string" then
                        --优先处理number 类型
                        local tmpKey = tonumber(key);
                        if tmpKey ~= nil then
                            key = tmpKey;
                        else
                            key = tostring(key)
                        end
                    end
                else
                    for i,v in ipairs(arg) do
                        if i == 1 then
                            key = tostring(v)
                        else
                            key = key .."_" .. tostring(v)
                        end
                    end
                end
                if key == nil or key == "switch" or key == "mt" or key == "get" or key == "parser" then
                    return nil
                end

                local row = v[key]
                if row ~= nil then
                    if getmetatable(row) == nil then
                        --Mlog:debug(" key:" .. key );
                        setmetatable(row, v.mt)
                        if v.parser ~= nil then
                            v.parser(row)
                        end
                    end
                --else
                    --Mlog:debug("table:" .. k .. " key:" .. key .. " load err! ");
                end

                return row
            end
        end
    end
end

TableLoader();
