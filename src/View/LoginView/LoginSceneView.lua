--
-- Author: Blackfe
--



local LoginSceneView = class("LoginSceneView",mtEventScene())

function LoginSceneView:ctor()
	LoginSceneView.super.ctor(self)
	
end

function LoginSceneView:initScene()
	if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(self)
    else
        cc.Director:getInstance():runWithScene(self)
    end     
end

function LoginSceneView:createScene()
	self:initScene()
end

function LoginSceneView:onEnter()
	LoginSceneView.super.ctor(self)
    print("LoginSceneView onEnter")

	mtNetworkService():connectLoginServer()

end

function LoginSceneView:onExit()
	LoginSceneView.super.ctor(self)
	print("LoginSceneView onExit") 
end

function LoginSceneView.open()
	local view = LoginSceneView.new()
	view:createScene()
	--这里以后肯定要进行特殊处理
end

return LoginSceneView

