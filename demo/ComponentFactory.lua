
local ComponentFactory = {}

local data = {
	"InputComponent" = {1}
}

function ComponentFactory.createComponent(compName,...)
	local compData = assert(data[compName])
	return require("compName").new(compName,compData[1],...)
end


return ComponentFactory