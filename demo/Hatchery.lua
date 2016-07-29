local Hatchery = class("Hatchery",GameObject)

function Hatchery:ctor()
	self:addComponent("NetworkControlComponent")
	self:addComponent("HatcheryBehaviorSM")
	if __CLIENT__ then
		self:addComponent("AnimationComponent")
	end
end

function Hatchery:update(delta)

end

return Hatchery