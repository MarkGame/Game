local Monster = class("Monster",GameObject)

function Monster:ctor()
	self:addComponent("AIComponent")
	self:addComponent("HumanBehaviorSM")
	if __CLIENT__ then
		self:addComponent("AnimationComponent")
	end
end

function Monster:update(delta)

end

return Monster