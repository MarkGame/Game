local StateMachine = class("StateMachine")

--[[--
port from Javascript State Machine Library
https://github.com/jakesgordon/javascript-state-machine
JS Version: 2.2.0
]]

StateMachine.VERSION = "2.2.0"

-- the event transitioned successfully from one state to another
StateMachine.SUCCEEDED = 1
-- the event was successfull but no state transition was necessary
StateMachine.NOTRANSITION = 2
-- the event was cancelled by the caller in a beforeEvent callback
StateMachine.CANCELLED = 3
-- the event is asynchronous and the caller is in control of when the transition occurs
StateMachine.PENDING = 4
-- the event was failure
StateMachine.FAILURE = 5

-- caller tried to fire an event that was innapropriate in the current state
StateMachine.INVALID_TRANSITION_ERROR = "INVALID_TRANSITION_ERROR"
-- caller tried to fire an event while an async transition was still pending
StateMachine.PENDING_TRANSITION_ERROR = "PENDING_TRANSITION_ERROR"
-- caller provided callback function threw an exception
StateMachine.INVALID_CALLBACK_ERROR = "INVALID_CALLBACK_ERROR"

StateMachine.WILDCARD = "*"
StateMachine.ASYNC = "ASYNC"

function StateMachine:ctor(target)
    StateMachine.super.ctor(self, "StateMachine")
    self.target_ = target
end

function StateMachine:setupState(cfg)
    assert(type(cfg) == "table", "StateMachine:ctor() - invalid config")

    -- cfg.initial allow for a simple string,
    -- or an table with { state = "foo", event = "setup", defer = true|false }
    if type(cfg.initial) == "string" then
        self.initial_ = {state = cfg.initial}
    else
        self.initial_ = clone(cfg.initial)
    end

    self.terminal_   = cfg.terminal or cfg.final
    self.events_     = cfg.events or {}

    self.states = {}
    self.map_        = {}
    self.current_    = nil
    self.inTransition_ = false

    if self.initial_ then
        self.initial_.event = self.initial_.event or "startup"
        self:addEvent_({name = self.initial_.event, from = "none", to = self.initial_.state})
    end

    for _, event in ipairs(self.events_) do
        self:addEvent_(event)
        local stateName = event.."State"
        if self.states[stateName] == nil then
            local state = require(stateName).new(self)
            state:setName(event)
            self.states[stateName] = state
        end
    end

    if self.initial_ and not self.initial_.defer then
        self:doEvent(self.initial_.event)
    end

    return self.target_
end

function StateMachine:isReady()
    return self.current_ ~= nil
end

function StateMachine:getState()
    return self.current_
end

function StateMachine:isState(state)
    if type(state) == "table" then
        for _, s in ipairs(state) do
            if s == self.current_:getName() then return true end
        end
        return false
    else
        return self.current_:getName() == state
    end
end

function StateMachine:canDoEvent(eventName)
    return not self.inTransition_
        and (self.map_[eventName][self.current_:getName()] ~= nil or self.map_[eventName][StateMachine.WILDCARD] ~= nil)
end

function StateMachine:cannotDoEvent(eventName)
    return not self:canDoEvent(eventName)
end

function StateMachine:isFinishedState()
    return self:isState(self.terminal_)
end

function StateMachine:doEventForce(name, ...)
    local from = self.current_:getName()
    local map = self.map_[name]
    local to = (map[from] or map[StateMachine.WILDCARD]) or from
    local args = {...}
    local nextState = self.states[to]
    local event = {
        name = name,
        from = from,
        to = to,
        args = args,
    }

    if self.inTransition_ then self.inTransition_ = false end
    nextState:beforeEvent_(event)
    if from == to then
        self.current_:afterEvent_(event)
        return StateMachine.NOTRANSITION
    end

    local tempState = self.current_
    self.current_ = nextState
    nextState:enterState_(event)
    tempState:afterEvent_(event)
    return StateMachine.SUCCEEDED
end

function StateMachine:doEvent(name, ...)
    assert(self.map_[name] ~= nil, string.format("StateMachine:doEvent() - invalid event %s", tostring(name)))

    local from = self.current_
    local map = self.map_[name]
    local to = (map[from] or map[StateMachine.WILDCARD]) or from
    local args = {...}
    local nextState = self.states[to]
    local event = {
        name = name,
        from = from,
        to = to,
        args = args,
    }

    if self.inTransition_ then
        self:onError_(event,
                      StateMachine.PENDING_TRANSITION_ERROR,
                      "event " .. name .. " inappropriate because previous transition did not complete")
        return StateMachine.FAILURE
    end

    if self:cannotDoEvent(name) then
        self:onError_(event,
                      StateMachine.INVALID_TRANSITION_ERROR,
                      "event " .. name .. " inappropriate in current state " .. self.current_)
        return StateMachine.FAILURE
    end

    if nextState:beforeEvent(event) == false then
        return StateMachine.CANCELLED
    end

    if from == to then
        self.current_:afterEvent(event)
        return StateMachine.NOTRANSITION
    end

    event.transition = function()
        self.inTransition_  = false
        local tempState = self.current_
        self.current_ = nextState
        nextState:enterState_(event)
        tempState:afterEvent_(event)
        return StateMachine.SUCCEEDED
    end

    event.cancel = function()
        -- provide a way for caller to cancel async transition if desired
        event.transition = nil
        self.current_:afterEvent(event)
    end

    self.inTransition_ = true
    local leave = self:leaveState_(event)
    if leave == false then
        event.transition = nil
        event.cancel = nil
        self.inTransition_ = false
        return StateMachine.CANCELLED
    elseif string.upper(tostring(leave)) == StateMachine.ASYNC then
        return StateMachine.PENDING
    else
        -- need to check in case user manually called transition()
        -- but forgot to return StateMachine.ASYNC
        if event.transition then
            return event.transition()
        else
            self.inTransition_ = false
        end
    end
end

function StateMachine:addEvent_(event)
    local from = {}
    if type(event.from) == "table" then
        for _, name in ipairs(event.from) do
            from[name] = true
        end
    elseif event.from then
        from[event.from] = true
    else
        -- allow "wildcard" transition if "from" is not specified
        from[StateMachine.WILDCARD] = true
    end

    self.map_[event.name] = self.map_[event.name] or {}
    local map = self.map_[event.name]
    for fromName, _ in pairs(from) do
        map[fromName] = event.to or fromName
    end
end

function StateMachine:leaveState_(event, transition)
    local specific = self.current_:leaveState_(event, transition)
    if specific == false then
        return false
    elseif string.upper(tostring(specific)) == StateMachine.ASYNC then
        return StateMachine.ASYNC
    end
end

function StateMachine:onError_(event, error, message)
    printf("%s [StateMachine] ERROR: error %s, event %s, from %s to %s", tostring(self.target_), tostring(error), event.name, event.from, event.to)
    printError(message)
end

return StateMachine