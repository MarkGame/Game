ExcelConfig = ExcelConfig or {}
ExcelConfig["HatcheryInfo"] = {}
ExcelConfig["HatcheryInfo"].list = {
{ BattleAreaID = 101,  Name = "第一战场初始阶段",  PoolID = 1000},
{ BattleAreaID = 101,  MonsterTotal = 30,  Name = "第一战场第一阶段",  PoolID = 1001},
{ BattleAreaID = 101,  MonsterTotal = 50,  Name = "第一战场第二阶段",  PoolID = 1002},
{ BattleAreaID = 101,  MonsterTotal = 50,  Name = "第一战场第三阶段",  PoolID = 1003},
{ BattleAreaID = 102,  Name = "第二战场初始阶段",  PoolID = 2000},
{ BattleAreaID = 102,  MonsterTotal = 30,  Name = "第二战场第一阶段",  PoolID = 2001},
{ BattleAreaID = 102,  MonsterTotal = 50,  Name = "第二战场第二阶段",  PoolID = 2002},
{ BattleAreaID = 102,  MonsterTotal = 50,  Name = "第二战场第三阶段",  PoolID = 2003}
}

ExcelConfig["HatcheryInfo"].key = {
"PoolID",
"Name",
"BattleAreaID",
"MonsterTotal"
}