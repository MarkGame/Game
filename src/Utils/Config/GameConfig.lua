--
-- Author: HLZ
-- Date: 2016-04-22 23:46:33
-- 怪兽信息管理类
--
GameConfig = {}
GameConfig.addConfig = {}
GameConfig.addConfig["Monster"] = "config/Monster.json"
GameConfig.addConfig["Skill"] = "config/Skill.json"
GameConfig.addConfig["SkillRange"] = "config/SkillRange.json"

GameConfig.indexConfig = 
{
  {file = GameConfig.addConfig["Monster"],key = "ID"},
  {file = GameConfig.addConfig["Skill"],key = "ID"},
  {file = GameConfig.addConfig["SkillRange"],key = "SkillRangeType"},
  {file = GameConfig.addConfig["SkillRange"],key = "SkillRange"},
}

