local Player = class("Player",GameObject)

function Player:ctor()
	self:addComponent("InputComponent")
	self:addComponent("HumanBehaviorSM")
	if __CLIENT__ then
		self:addComponent("AnimationComponent")
	end
end

function Player:update(delta)

end

return Player