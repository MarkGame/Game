--[[Writen by vic
日志输出接口, 多个参数，用逗号分隔

Exported API:

Example:
logDebug(1)
logTrace("222")
--]]

require("Utils.Queue")

--日志输出级别
local logCurrentLevel = 5;

--日志定义级别
local log_debug =		5;
local log_trace =		4;
local log_info =		3;
local log_warn =		2;
local log_error =		1;

local print_to_file = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS
local file = nil

if print_to_file == true then
    file = io.open("log.lua", "w");
end

local CACHE_LEN     =   5

LogCache = Queue:new()


--[[
输出日志
接受可变参数
示例：
printLog(1, "222")
]]
local function printLog(level, msg)
    if LogCache:size() >= CACHE_LEN then
        LogCache:pop()
    end
    LogCache:push(level .. " ".. msg)

    --SystemTools 需要进行Lua绑定
    --SystemTools:printLog(level .. " ".. msg);

    if print_to_file == true and file ~= nil then
        file:write(level .. " ".. msg.."\n");
        file:flush()
    end
--    print(level..""..msg)
end

function logDebug(...)
    local arg = {...}
    --过滤
    if logCurrentLevel < log_debug then
        return;
    end
    --输出
    local printResult = "";
    for i,v in ipairs(arg) do
        printResult = printResult .. tostring(v) .. "  ";
    end
    printLog("[DEBUG]", printResult);
end

function logTrace(...)
    local arg = {...}

    --过滤
    if logCurrentLevel < log_trace then
        return;
    end
    --输出
    local printResult = "";
    for i,v in ipairs(arg) do
        printResult = printResult .. tostring(v) .. "  ";
    end
    printLog("[TRACE]", printResult);
end

function logInfo(...)
    local arg = {...}

    --过滤
    if logCurrentLevel < log_info then
        return;
    end
    --输出
    local printResult = "";
    for i,v in ipairs(arg) do
        printResult = printResult .. tostring(v) .. "  ";
    end
    printLog("[INFO]", printResult);
end

function logWarn(...)
    local arg = {...}

    --过滤
    if logCurrentLevel < log_warn then
        return;
    end
    --输出
    local printResult = "";
    for i,v in ipairs(arg) do
        printResult = printResult .. tostring(v) .. "  ";
    end
    printLog("[WARN]", printResult);
end

function logError(...)
    local arg = {...}

    --过滤
    if logCurrentLevel < log_error then
        return;
    end
    --输出
    local printResult = "";
    for i,v in ipairs(arg) do
        printResult = printResult .. tostring(v) .. "  ";
    end
    printLog("[ERROR]", printResult);
end

PRINT_PROPERTY = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS
function logProperty(...)
    local arg = {...}
    --过滤
    if PRINT_PROPERTY ~= true then
        return;
    end
    --输出
    local printResult = "";
    for i,v in ipairs(arg) do
        printResult = printResult .. tostring(v) .. "  ";
    end
    printLog("[PROPERTY]", printResult);
end


--[[  打印table
@lua_table  表对象
@indent    缩进显示 数字
@tag   标签，说明打印的地方或者名称
]]
function printLuaTable (lua_table, indent, tag)
    if tag ~= "" and tag ~= nil then
        logInfo("-------------------------" .. tag .. "-------------------------")
    end

    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        local formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" and v ~= lua_table then
            logInfo(formatting)
            printLuaTable(v, indent + 1, "")
            logInfo(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            logInfo(formatting..szValue..",")
        end
    end
end

function printTime(log)
    if PRINT_TIME_FLAG == true then
        local data = os.clock()
        logDebug(data.." "..log.."\n")
    end
end
