local Component = require("Component")

local InputComponent = class("InputComponent",Component)


function InputComponent:ctor( ... )
	-- body
	self.moveDirection = cc.p(0,0)
	return InputComponent.super.ctor(self,...)
end


function InputComponent:onBind_()
    self.listener = cc.EventListenerKeyboard:create()

    self.listener:registerScriptHandler(handler(self,self.pressedFunc), cc.Handler.EVENT_KEYBOARD_PRESSED)
    self.listener:registerScriptHandler(handler(self,releasedFunc),cc.Handler.EVENT_KEYBOARD_RELEASED)
end



function InputComponent:pressedFunc(keyCode, event)
    if keyCode == cc.KeyCode.KEY_LEFT_ARROW then
        self.moveDirection.x = self.moveDirection.x -1
    elseif keyCode == cc.KeyCode.KEY_RIGHT_ARROW then
        self.moveDirection.x = self.moveDirection.x +1
    elseif keyCode == cc.KeyCode.KEY_UP_ARROW then
        self.moveDirection.y = self.moveDirection.y +1
    elseif keyCode == cc.KeyCode.KEY_DOWN_ARROW then
        self.moveDirection.y = self.moveDirection.y -1
    elseif keyCode == cc.KeyCode.KEY_S then   --吞噬键
    elseif keyCode == cc.KeyCode.KEY_A then   --技能A键
    elseif keyCode == cc.KeyCode.KEY_W then   --技能B键
    elseif keyCode == cc.KeyCode.KEY_D then   --技能C键
    end
end

function InputComponent:releasedFunc(keyCode, event)
    if keyCode == cc.KeyCode.KEY_LEFT_ARROW then
        self.moveDirection.x = self.moveDirection.x +1
    elseif keyCode == cc.KeyCode.KEY_RIGHT_ARROW then
        self.moveDirection.x = self.moveDirection.x -1
    elseif keyCode == cc.KeyCode.KEY_UP_ARROW then
        self.moveDirection.y = self.moveDirection.y -1
    elseif keyCode == cc.KeyCode.KEY_DOWN_ARROW then
        self.moveDirection.y = self.moveDirection.y +1
    elseif keyCode == cc.KeyCode.KEY_S then   --吞噬键
    elseif keyCode == cc.KeyCode.KEY_A then   --技能A键
    elseif keyCode == cc.KeyCode.KEY_W then   --技能B键
    elseif keyCode == cc.KeyCode.KEY_D then   --技能C键
    end
end

function InputComponent:update(delta)
	if self.moveDirection ~= cc.p(0,0) then
		self.target:pushAction(CreateActionData(ActionType.MOVE,self.moveDirection))
	end
end 

function InputComponent:unBind_()
	if self.listener ~= nil then
		self.listener:unregisterScriptHandler()
		self.listener = nil
	end
end


return InputComponent