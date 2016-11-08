ExcelConfig = ExcelConfig or {}
ExcelConfig["Action"] = {}
ExcelConfig["Action"].list = {
{ ActionName = "toIdle",  Name = "待机",  EName = "呵呵",  ActionTo = "idle",  ActionFrom = "search|autoMove|chase|escape|devour|useExclusive|selectTarget",  ERes = "res/Expression/expression (24).png",  Type = 1,  ID = 1001,  Desc = "停止当前行为，进入思考阶段"},
{ ActionName = "toSearch",  Name = "进攻",  EName = "哈哈",  ActionTo = "search",  ActionFrom = "idle|autoMove|chase|escape|devour|useExclusive|selectTarget",  ERes = "res/Expression/expression (3).png",  Type = 1,  ID = 1002,  Desc = "执行搜寻"},
{ ActionName = "toSelect",  Name = "逃跑",  EName = "吐舌",  ActionTo = "selectTarget",  ActionFrom = "idle|autoMove|chase|escape|devour|useExclusive|search",  ERes = "res/Expression/expression (4).png",  Type = 1,  ID = 1003,  Desc = "去选择目标"},
{ ActionName = "toAutoMove",  Name = "散步",  EName = "吐舌",  ActionTo = "autoMove",  ActionFrom = "idle|search|chase|escape|devour|useExclusive|selectTarget",  ERes = "res/Expression/expression (5).png",  Type = 1,  ID = 1004,  Desc = "随机移动"},
{ ActionName = "toChase",  Name = "待机",  EName = "吐舌",  ActionTo = "chase",  ActionFrom = "idle|search|autoMove|escape|devour|useExclusive|selectTarget",  ERes = "res/Expression/expression (6).png",  Type = 1,  ID = 1005,  Desc = "追捕"},
{ ActionName = "toEscape",  Name = "进攻",  EName = "吐舌",  ActionTo = "escape",  ActionFrom = "idle|search|chase|devour|useExclusive|selectTarget|autoMove",  ERes = "res/Expression/expression (7).png",  Type = 1,  ID = 1006,  Desc = "逃跑"},
{ ActionName = "toDevour",  Name = "逃跑",  EName = "吐舌",  ActionTo = "devour",  ActionFrom = "idle|search|chase|escape|useExclusive|selectTarget|autoMove",  ERes = "res/Expression/expression (8).png",  Type = 1,  ID = 1007,  Desc = "吞噬"},
{ ActionName = "toUseExclusive",  Name = "散步",  EName = "吐舌",  ActionTo = "useExclusive",  ActionFrom = "idle|search|chase|escape|devour|selectTarget|autoMove",  ERes = "res/Expression/expression (9).png",  Type = 1,  ID = 1008,  Desc = "使用专属技能"},
{ ActionName = "toStop",  Name = "散步",  EName = "吐舌",  ActionTo = "stop",  ActionFrom = "idle|search|chase|escape|devour|useExclusive|selectTarget|autoMove",  ERes = "res/Expression/expression (10).png",  Type = 1,  ID = 1009,  Desc = "终止一切行为（怪兽销毁 和 游戏结束时才能使用）"}
}

ExcelConfig["Action"].key = {
"ID",
"Name",
"Type",
"Desc",
"ActionName",
"ActionFrom",
"ActionTo",
"EName",
"ERes"
}