--[[
    将全部的技能都统一整理调用
]]

--探测
local DetectSkillLogic = require("GameLogic.Skill.SkillLogic.DetectSkillLogic")
local DetectSkillView = require("View.SkillView.DetectSkillView")
--吞噬
local DevourSkillLogic = require("GameLogic.Skill.SkillLogic.DevourSkillLogic")
local DevourSkillView = require("View.SkillView.DevourSkillView")
--减速
local DecelerateSkillLogic = require("GameLogic.Skill.SkillLogic.DecelerateSkillLogic")
local DecelerateSkillView = require("View.SkillView.DecelerateSkillView")
--加速
local AccelerateSkillLogic = require("GameLogic.Skill.SkillLogic.AccelerateSkillLogic")
local AccelerateSkillView = require("View.SkillView.AccelerateSkillView")
--禁锢
local ImprisonSkillLogic = require("GameLogic.Skill.SkillLogic.ImprisonSkillLogic")
local ImprisonSkillView = require("View.SkillView.ImprisonSkillView")
--传送
local TransferSkillLogic = require("GameLogic.Skill.SkillLogic.TransferSkillLogic")
local TransferSkillView = require("View.SkillView.TransferSkillView")
--隐身
local InvisibleSkillLogic = require("GameLogic.Skill.SkillLogic.InvisibleSkillLogic")
local InvisibleSkillView = require("View.SkillView.InvisibleSkillView")
--闪耀
local ShineSkillLogic = require("GameLogic.Skill.SkillLogic.ShineSkillLogic")
local ShineSkillView = require("View.SkillView.ShineSkillView")
--恐惧
local FearSkillLogic = require("GameLogic.Skill.SkillLogic.FearSkillLogic")
local FearSkillView = require("View.SkillView.FearSkillView")
--分身
local CloneSkillLogic = require("GameLogic.Skill.SkillLogic.CloneSkillLogic")
local CloneSkillView = require("View.SkillView.CloneSkillView")
--子弹
local ShootSkillLogic = require("GameLogic.Skill.skillLogic.ShootSkillLogic")
local ShootSkillView = require("View.SkillView.ShootSkillView")

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