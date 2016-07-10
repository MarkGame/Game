local sparser = require "sprotoparser"

local game_proto = {}
local types = [[
.package {
  type 0 : integer
  session 1 : integer
}

.Position {
  x 0 : integer
  y 1 : integer
  z 2 : integer
  o 3 : integer
}

.MoveInfo {
  account 0 : integer
  pos 1 : Position
}
]]


game_proto.types = sparser.parse(types)

local c2s = [[
move 1 {
	request {
		pos 0 : Position
	}
	response {
		result 0 : integer
	}
}

playersInfo 2 {
    response {
      player 0 : *MoveInfo
    }
}

myInfo 3 {
    response {
      pos 0 : Position
    }
}
]]

local s2c = [[
playerMove 1 {
  request {
    player 0 : MoveInfo
  }
}
]]

game_proto.c2s = sparser.parse(types .. c2s)
game_proto.s2c = sparser.parse(types .. s2c)
return game_proto
