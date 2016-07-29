ActionType = {
	MOVE = 1,
	SKILL = 2
}

function CreateActionData(t,data)
	return { __type = t, __data = data}
end