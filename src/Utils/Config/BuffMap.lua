--[[
    将全部的BUFF都统一整理调用
]]

--减速
local DecelerateBuffLogic = require("GameLogic.Buff.BuffLogic.DecelerateBuffLogic")
--加速
local AccelerateBuffLogic = require("GameLogic.Buff.BuffLogic.AccelerateBuffLogic")


BuffMap = BuffMap or {}

BuffMap[10001] = {buffLogic = DecelerateBuffLogic.createBuff,buffView = nil}
BuffMap[10002] = {buffLogic = DecelerateBuffLogic.createBuff,buffView = nil}
BuffMap[10003] = {buffLogic = DecelerateBuffLogic.createBuff,buffView = nil}

BuffMap[10004] = {buffLogic = AccelerateBuffLogic.createBuff,buffView = nil}
BuffMap[10005] = {buffLogic = AccelerateBuffLogic.createBuff,buffView = nil}
BuffMap[10006] = {buffLogic = AccelerateBuffLogic.createBuff,buffView = nil}

-- BuffMap[10007] = {buffLogic = DecelerateSkillLogic.createBuff,buffView = nil}
-- BuffMap[10008] = {buffLogic = DecelerateSkillLogic.createBuff,buffView = nil}
-- BuffMap[10009] = {buffLogic = DecelerateSkillLogic.createBuff,buffView = nil}

-- BuffMap[10010] = {buffLogic = AccelerateSkillLogic.createBuff,buffView = nil}
-- BuffMap[10011] = {buffLogic = AccelerateSkillLogic.createBuff,buffView = nil}
-- BuffMap[10012] = {buffLogic = AccelerateSkillLogic.createBuff,buffView = nil}

-- BuffMap[10013] = {buffLogic = ImprisonSkillLogic.createBuff,buffView = nil}
-- BuffMap[10014] = {buffLogic = ImprisonSkillLogic.createBuff,buffView = nil}
-- BuffMap[10015] = {buffLogic = ImprisonSkillLogic.createBuff,buffView = nil}

-- BuffMap[10016] = {buffLogic = TransferSkillLogic.createBuff,buffView = nil}
-- BuffMap[10017] = {buffLogic = TransferSkillLogic.createBuff,buffView = nil}
-- BuffMap[10018] = {buffLogic = TransferSkillLogic.createBuff,buffView = nil}

-- BuffMap[10019] = {buffLogic = InvisibleSkillLogic.createBuff,buffView = nil}
-- BuffMap[10020] = {buffLogic = InvisibleSkillLogic.createBuff,buffView = nil}
-- BuffMap[10021] = {buffLogic = InvisibleSkillLogic.createBuff,buffView = nil}

-- BuffMap[10022] = {buffLogic = ShineSkillLogic.createBuff,buffView = nil}

-- BuffMap[10023] = {buffLogic = FearSkillLogic.createBuff,buffView = nil}
-- BuffMap[10024] = {buffLogic = FearSkillLogic.createBuff,buffView = nil}
-- BuffMap[10025] = {buffLogic = FearSkillLogic.createBuff,buffView = nil}

-- BuffMap[10026] = {buffLogic = CloneSkillLogic.createBuff,buffView = nil}
