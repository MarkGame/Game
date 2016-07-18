--
-- Author: HLZ
-- Date: 2015-12-29 14:56:16
-- 预加载场景
--[[
    对所需要的资源进行统一化的加载
    切换场景 不对必要的资源进行释放
]]

local LoadingSceneView = class("LoadingSceneView",mtEventScene())

function LoadingSceneView:ctor()
	LoadingSceneView.super.ctor(self)
	
end

function LoadingSceneView:initScene()
	if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(self)
    else
        cc.Director:getInstance():runWithScene(self)
    end

    -- require("GameLogic/Data/clientDBGame")
    -- require("GameLogic/Data/TableParser")
    -- TableLoader()
            
end

function LoadingSceneView:createScene()

	self:initScene()

 --    self.layer = cc.Layer:create()
 --    self:addChild(self.layer)

	-- self.guiNode = createGUINode(res.RES_START_GAME)
	-- self.layer:addChild(self.guiNode,10)

	
    g_game:enterStartScene()

end

function LoadingSceneView:onEnter()
	LoadingSceneView.super.ctor(self)
    print("LoadingSceneView onEnter") 
end

function LoadingSceneView:onExit()
	LoadingSceneView.super.ctor(self)
	print("LoadingSceneView onExit") 
end

function LoadingSceneView.open()
	local view = LoadingSceneView.new()
	view:createScene()
	--这里以后肯定要进行特殊处理
end

return LoadingSceneView

