print(_VERSION)

require "functions"

local socket = require "socket"
local login_proto = require "login_proto"
local game_proto = require "game_proto"
local sparser = require "sprotoparser"
local sproto = require "sproto"

local scheduler = cc.Director:getInstance():getScheduler()

local fd = assert(socket.connect("139.196.53.57", 6254))
fd:settimeout(0)
local host = sproto.new(login_proto.s2c):host("package")
local request = host:attach(sproto.new(login_proto.c2s))

local session = 0
local last = ""
local bLogin = false
local RESPONSE = {}
local REQUEST = {}

local sessionCB = {}

local myPos
local otherPlayers

local function send_package(fd,pack)
      local package = string.pack(">s2",pack)
      fd:send(package)
end
local function send_request(name,args)
	  print("send_request "..name)
      session = session + 1
      if RESPONSE[name] == nil then
      else
        sessionCB[session] = RESPONSE[name]
      end
      
      local str = request(name,args,session)
      send_package(fd,str)
end

local function unpack_package(text)
      local size = #text
      if size < 2 then
         return _,text
      end
      local s = text:byte(1)* 256 + text:byte(2)
      if size < s + 2 then
         return _,text
      end
	  print("v "..text:sub(3,2+s))
      return text:sub(3,2+s),text:sub(3+s)
end
local input,recvt,sendt,status
local function recv_package(last)
	  
	  recvt,sendt,status = socket.select({fd},nil,1)
	  while #recvt > 0 do
	    local response,receive_status = fd:receive(1)
		if receive_status ~= "closed" then
		    if response then
				return unpack_package(last .. response)
			end
		else
			break
		end
	  end
	  
	  return _,last
end

local function deal_request(name,args)
      print("REQUEST",name)
      if args then
         dump(args)
      end
end

local function deal_response(session,args)
      print("RESPONSE",session)
      if args then
         dump(args)
      end

      if sessionCB[session] == nil then
        return
      end

      local f = sessionCB[session]
      f(args)
end

local function deal_package(t,...)
  if t == "REQUEST" then
     deal_request(...)
  else
    assert(t=="RESPONSE")
    deal_response(...)
  end
end

local function dispatch_package()
  while true do
    local v
    v,last = recv_package(last)
    if not v then
      break
    end
	
    deal_package(host:dispatch(v))
  end
end


function RESPONSE:playersInfo()
  local bFound = false
  for i,v in ipairs(self.player) do
    local otherPlayer
    if otherPlayers[v.account] == nil then
      otherPlayer = {}
      otherPlayers[v.account] = otherPlayer
    end

    otherPlayer.pos = v.pos
  end
end

function REQUEST:playerMove()
  print("player "..self.account.." move to "..self.pos.x.." "..self.pos.y.." "..self.pos.z)
end

function RESPONSE:move()
end

function RESPONSE:myInfo()
  myPos = self.pos
end

function RESPONSE:login()
    bLogin = true
    host = sproto.new(game_proto.s2c):host("package")
    request = host:attach(sproto.new(game_proto.c2s))
    send_request("myInfo")
end


local function move()
  print("move")
  if myPos ~= nil then
    local offset = {}
    offset.x = math.random(0,10)
    offset.y = math.random(0,10)
    offset.z = math.random(0,10)
    offset.o = math.random(0,10)
    myPos.x = myPos.x + offset.x
    myPos.y = myPos.y + offset.y
    myPos.z = myPos.z + offset.z
    myPos.o = myPos.o + offset.o
    send_request("move",{pos = myPos})
  end
end

local count = 0

send_request("login",{username="blackfe",password="123456"})
local function loop_message()
      dispatch_package()

        if bLogin == false then
        else
           --send_request("playersInfo")
           count = count + 1
           if math.fmod(count,5) == 0 then
             move()
           end
        end
end

scheduler:scheduleScriptFunc(loop_message, 0.01,false)
