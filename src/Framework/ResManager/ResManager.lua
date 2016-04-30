--
-- Author: HLZ
-- Date: 2016-01-05 13:42:16
-- 管理UI 资源类

require "Framework.ResManager.ResourceIDList"


ResManager = class("ResManager");
ResManager.__index = ResManager;

function ResManager:getInstance()
	if self.instance == nil then 
	   self.instance = ResManager.new()
	end
	return self.instance
end

function ResManager:ctor()

end

function createGUINode(file)
    --logDebug(file) --打印资源名字，以后方便查看

    local node 
    local fileExtName = getExtension(file);
	if fileExtName == "csb" then   --csb格式
	    node = ccs.GUIReader:getInstance():widgetFromBinaryFile(file);
	else                           --json格式
	    node = ccs.GUIReader:getInstance():widgetFromJsonFile(file);
	end

	return node 

end


