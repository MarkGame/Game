--
-- Author: zone
-- Date: 2016-03-15 12:12:29
--添加搜索路径
local search_path = {
    "res/publish/resource",
    "res/publish",
    "res/config"
}

SearchPathConfig = class("SearchPathConfig")

--更新完再设置
function SearchPathConfig.init()
    local cachePath = cc.FileUtils:getInstance():getWritablePath();
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        cachePath = cachePath .. "assets/";
    end
end

for i,v in ipairs(search_path) do
    cc.FileUtils:getInstance():addSearchPath(v)
    cc.FileUtils:getInstance():addSearchPath("../" .. v)
    cc.FileUtils:getInstance():addSearchPath("../../" .. v)
end

return SearchPathConfig;