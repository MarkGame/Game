--
-- Author: HLZ
-- Date: 2016-04-22 23:46:33
-- 
--
GameConfig = {}
GameConfig.addConfig = {}
GameConfig.addConfig["Monster"] = "config/Monster.json"
GameConfig.addConfig["Skill"] = "config/Skill.json"
GameConfig.addConfig["SkillRange"] = "config/SkillRange.json"
GameConfig.addConfig["Battle"] = "config/Battle.json"
GameConfig.addConfig["Hatchery"] = "config/Hatchery.json"
GameConfig.addConfig["HatcheryInfo"] = "config/HatcheryInfo.json"
GameConfig.addConfig["Buff"] = "config/Buff.json"
--GameConfig.addConfig["Common"] = "config/Common.json"

GameConfig.indexConfig = 
{
  {file = GameConfig.addConfig["Monster"],key = "ID"},
  {file = GameConfig.addConfig["Skill"],key = "ID"},
  {file = GameConfig.addConfig["Buff"],key = "ID"},
  {file = GameConfig.addConfig["SkillRange"],key = "SkillRangeType"},
  {file = GameConfig.addConfig["SkillRange"],key = "SkillRange"},
  --{file = GameConfig.addConfig["Common"]},
  {file = GameConfig.addConfig["Hatchery"],key = "BattleAreaID"},
  {file = GameConfig.addConfig["HatcheryInfo"],key = "PoolID"},
  {file = GameConfig.addConfig["Battle"],key = "BattleAreaID"},
}

