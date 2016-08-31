--[[
    将全部的技能都统一整理调用
]]

--探测
local DetectSkillLogic = require("GameLogic.Skill.SkillLogic.DetectSkillLogic")
local DetectSkillView = require("GameLogic.Skill.SkillLogic.DetectSkillView")
--吞噬
local DevourSkillLogic = require("GameLogic.Skill.SkillLogic.DevourSkillLogic")
local DevourSkillView = require("GameLogic.Skill.SkillLogic.DevourSkillView")
--减速
local DecelerateSkillLogic = require("GameLogic.Skill.SkillLogic.DecelerateSkillLogic")
local DecelerateSkillView = require("GameLogic.Skill.SkillLogic.DecelerateSkillView")
--加速
local AccelerateSkillLogic = require("GameLogic.Skill.SkillLogic.AccelerateSkillLogic")
local AccelerateSkillView = require("GameLogic.Skill.SkillLogic.AccelerateSkillView")
--禁锢
local ImprisonSkillLogic = require("GameLogic.Skill.SkillLogic.ImprisonSkillLogic")
local ImprisonSkillView = require("GameLogic.Skill.SkillLogic.ImprisonSkillView")
--传送
local TransferSkillLogic = require("GameLogic.Skill.SkillLogic.TransferSkillLogic")
local TransferSkillView = require("GameLogic.Skill.SkillLogic.TransferSkillView")
--隐身
local InvisibleSkillLogic = require("GameLogic.Skill.SkillLogic.InvisibleSkillLogic")
local InvisibleSkillView = require("GameLogic.Skill.SkillLogic.InvisibleSkillView")
--闪耀
local ShineSkillLogic = require("GameLogic.Skill.SkillLogic.ShineSkillLogic")
local ShineSkillView = require("GameLogic.Skill.SkillLogic.ShineSkillView")
--恐惧
local FearSkillLogic = require("GameLogic.Skill.SkillLogic.FearSkillLogic")
local FearSkillView = require("GameLogic.Skill.SkillLogic.FearSkillView")
--分身
local CloneSkillLogic = require("GameLogic.Skill.SkillLogic.CloneSkillLogic")
local CloneSkillView = require("GameLogic.Skill.SkillLogic.CloneSkillView")
--子弹
local ShootSkillLogic = require("GameLogic.Skill.skillLogic.ShootSkillLogic")
local ShootSkillView = require("GameLogic.Skill.skillLogic.ShootSkillView")

SkillMap = SkillMap or {}

SkillMap[10001] = {skillLogic = DetectSkillLogic.createSkill,skillView = DetectSkillView.createSkill}
SkillMap[10002] = {skillLogic = DetectSkillLogic.createSkill,skillView = DetectSkillView.createSkill}
SkillMap[10003] = {skillLogic = DetectSkillLogic.createSkill,skillView = DetectSkillView.createSkill}

SkillMap[10004] = {skillLogic = DevourSkillLogic.createSkill,skillView = DevourSkillView.createSkill}
SkillMap[10005] = {skillLogic = DevourSkillLogic.createSkill,skillView = DevourSkillView.createSkill}
SkillMap[10006] = {skillLogic = DevourSkillLogic.createSkill,skillView = DevourSkillView.createSkill}

SkillMap[10007] = {skillLogic = DecelerateSkillLogic.createSkill,skillView = DecelerateSkillView.createSkill}
SkillMap[10008] = {skillLogic = DecelerateSkillLogic.createSkill,skillView = DecelerateSkillView.createSkill}
SkillMap[10009] = {skillLogic = DecelerateSkillLogic.createSkill,skillView = DecelerateSkillView.createSkill}

SkillMap[10010] = {skillLogic = AccelerateSkillLogic.createSkill,skillView = AccelerateSkillView.createSkill}
SkillMap[10011] = {skillLogic = AccelerateSkillLogic.createSkill,skillView = AccelerateSkillView.createSkill}
SkillMap[10012] = {skillLogic = AccelerateSkillLogic.createSkill,skillView = AccelerateSkillView.createSkill}

SkillMap[10013] = {skillLogic = ImprisonSkillLogic.createSkill,skillView = ImprisonSkillView.createSkill}
SkillMap[10014] = {skillLogic = ImprisonSkillLogic.createSkill,skillView = ImprisonSkillView.createSkill}
SkillMap[10015] = {skillLogic = ImprisonSkillLogic.createSkill,skillView = ImprisonSkillView.createSkill}

SkillMap[10016] = {skillLogic = TransferSkillLogic.createSkill,skillView = TransferSkillView.createSkill}
SkillMap[10017] = {skillLogic = TransferSkillLogic.createSkill,skillView = TransferSkillView.createSkill}
SkillMap[10018] = {skillLogic = TransferSkillLogic.createSkill,skillView = TransferSkillView.createSkill}

SkillMap[10019] = {skillLogic = InvisibleSkillLogic.createSkill,skillView = InvisibleSkillView.createSkill}
SkillMap[10020] = {skillLogic = InvisibleSkillLogic.createSkill,skillView = InvisibleSkillView.createSkill}
SkillMap[10021] = {skillLogic = InvisibleSkillLogic.createSkill,skillView = InvisibleSkillView.createSkill}

SkillMap[10022] = {skillLogic = ShineSkillLogic.createSkill,skillView = ShineSkillView.createSkill}

SkillMap[10023] = {skillLogic = FearSkillLogic.createSkill,skillView = FearSkillView.createSkill}
SkillMap[10024] = {skillLogic = FearSkillLogic.createSkill,skillView = FearSkillView.createSkill}
SkillMap[10025] = {skillLogic = FearSkillLogic.createSkill,skillView = FearSkillView.createSkill}

SkillMap[10026] = {skillLogic = CloneSkillLogic.createSkill,skillView = CloneSkillView.createSkill}


SkillMap[10031] = {skillLogic = ShootSkillLogic.createSkill,skillView = ShootSkillView.createSkill}