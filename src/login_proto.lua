local sparser = require "sprotoparser"

local login_proto = {}

login_proto.c2s = sparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

login 1 {
	request {
		type 0 : integer        # 0 = login, 1 = register
		username 1 : string
		password 2 : string
	}
	response {
		account 0 : integer
	}
}

]]

login_proto.s2c = sparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}
]]

return login_proto
