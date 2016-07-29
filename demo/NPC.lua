local Monster = class("Monster",GameObject)

function Monster:ctor()
	self:addComponent("NetworkActionComponent")
	self:addComponent("HumanBehaviorSM")
	if __CLIENT__ then
		self:addComponent("AnimationComponent")
	end
end

function Monster:update(delta)

end

return Monster