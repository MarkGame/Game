local State = class("State")

function State:ctor(fsm)
	self.name = ""
	self.fsm = fsm
end

function State:getName()
	return self.name
end

function State:setName(name)
	self.name = name
end

function State:onBefore(event)
end

function State:onAfter(event)
end

function State:onLeave(event)
end

function State:onEnter(event)
end

function State:update()
end

return State