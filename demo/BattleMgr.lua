local BattleMgr = class("BattleMgr")

local ACTION_MASK = 0x10

function BattleMgr:ctor()
	self.gameObjectMap = {}
end

function BattleMgr:addGameObject(go)
	table.insert(self.gameObjectMap,go)
end

function BattleMgr:updateAction(delta)
	for i,v in ipairs(self.gameObjectMap) do
		local comp =  v:getComponentByMask(ACTION_MASK)
		if comp ~= nil then
			comp:update(delta)
		end
	end
end

function BattleMgr:updateSM(delta)
end

function BattleMgr:update(delta)
	self:updateAction(delta)
	self:updateSM(delta)
end

return BattleMgr