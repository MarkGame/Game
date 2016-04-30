
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:ctor()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
