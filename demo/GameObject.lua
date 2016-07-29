
local ComponentFactory = require("ComponentFactory")
local GameObject = class("GameObject")


function GameObject:ctor()
    self.compMask = 0
    self.actionList = {}
end

function GameObject:getComponent()
end

function GameObject:hasComponent()
end

function GameObject:addComponent(...)
    local component = ComponentFactory.createComponent(...)
    component:bind_(self)
end

function GameObject:pushAction(actionData)
    -- body
    table.insert(self.actionList,actionData)
end

function GameObject:getAction()
    return self.actionList[1]
end

return GameObject