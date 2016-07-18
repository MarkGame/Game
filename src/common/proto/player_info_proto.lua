local sparser = require "sprotoparser"

local player_proto = {}
local player_info = [[
.Skill {
    id 0 : integer
    level 1 : integer
}
.Base {
  hp 0 : integer
  level 1 : integer
  skillList 2 : *Skill
}

]]

player_proto.player_info = sparser.parse(player_info)
return player_proto
