--[[
    将全部的技能都统一整理调用
]]

--探测
local DetectSkillLogic = require("GameLogic.Skill.SkillLogic.DetectSkillLogic")
--吞噬
local DevourSkillLogic = require("GameLogic.Skill.SkillLogic.DevourSkillLogic")
--减速
local DecelerateSkillLogic = require("GameLogic.Skill.SkillLogic.DecelerateSkillLogic")
--加速
local AccelerateSkillLogic = require("GameLogic.Skill.SkillLogic.AccelerateSkillLogic")
--禁锢
local ImprisonSkillLogic = require("GameLogic.Skill.SkillLogic.ImprisonSkillLogic")
--传送
local TransferSkillLogic = require("GameLogic.Skill.SkillLogic.TransferSkillLogic")
--隐身
local InvisibleSkillLogic = require("GameLogic.Skill.SkillLogic.InvisibleSkillLogic")
--闪耀
local ShineSkillLogic = require("GameLogic.Skill.SkillLogic.ShineSkillLogic")
--恐惧
local FearSkillLogic = require("GameLogic.Skill.SkillLogic.FearSkillLogic")
--分身
local CloneSkillLogic = require("GameLogic.Skill.SkillLogic.CloneSkillLogic")


SkillMap = SkillMap or {}

SkillMap[10001] = {skillLogic = DetectSkillLogic.createSkill,skillView = nil}
SkillMap[10002] = {skillLogic = DetectSkillLogic.createSkill,skillView = nil}
SkillMap[10003] = {skillLogic = DetectSkillLogic.createSkill,skillView = nil}

SkillMap[10004] = {skillLogic = DevourSkillLogic.createSkill,skillView = nil}
SkillMap[10005] = {skillLogic = DevourSkillLogic.createSkill,skillView = nil}
SkillMap[10006] = {skillLogic = DevourSkillLogic.createSkill,skillView = nil}

SkillMap[10007] = {skillLogic = DecelerateSkillLogic.createSkill,skillView = nil}
SkillMap[10008] = {skillLogic = DecelerateSkillLogic.createSkill,skillView = nil}
SkillMap[10009] = {skillLogic = DecelerateSkillLogic.createSkill,skillView = nil}

SkillMap[10010] = {skillLogic = AccelerateSkillLogic.createSkill,skillView = nil}
SkillMap[10011] = {skillLogic = AccelerateSkillLogic.createSkill,skillView = nil}
SkillMap[10012] = {skillLogic = AccelerateSkillLogic.createSkill,skillView = nil}

SkillMap[10013] = {skillLogic = ImprisonSkillLogic.createSkill,skillView = nil}
SkillMap[10014] = {skillLogic = ImprisonSkillLogic.createSkill,skillView = nil}
SkillMap[10015] = {skillLogic = ImprisonSkillLogic.createSkill,skillView = nil}

SkillMap[10016] = {skillLogic = TransferSkillLogic.createSkill,skillView = nil}
SkillMap[10017] = {skillLogic = TransferSkillLogic.createSkill,skillView = nil}
SkillMap[10018] = {skillLogic = TransferSkillLogic.createSkill,skillView = nil}

SkillMap[10019] = {skillLogic = InvisibleSkillLogic.createSkill,skillView = nil}
SkillMap[10020] = {skillLogic = InvisibleSkillLogic.createSkill,skillView = nil}
SkillMap[10021] = {skillLogic = InvisibleSkillLogic.createSkill,skillView = nil}

SkillMap[10022] = {skillLogic = ShineSkillLogic.createSkill,skillView = nil}

SkillMap[10023] = {skillLogic = FearSkillLogic.createSkill,skillView = nil}
SkillMap[10024] = {skillLogic = FearSkillLogic.createSkill,skillView = nil}
SkillMap[10025] = {skillLogic = FearSkillLogic.createSkill,skillView = nil}

SkillMap[10026] = {skillLogic = CloneSkillLogic.createSkill,skillView = nil}
