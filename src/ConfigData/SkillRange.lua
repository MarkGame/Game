ExcelConfig = ExcelConfig or {}
ExcelConfig["SkillRange"] = {}
ExcelConfig["SkillRange"].list = {
{ SkillRangeType = 1,  PosTable = "0,-1|1,-1|1,0|1,1|0,1|-1,1|-1,0|-1,-1",  SkillRange = 1,  AnimName = "全面型 范围1"},
{ SkillRangeType = 1,  PosTable = "0,-1|1,-1|1,0|1,1|0,1|-1,1|-1,0|-1,-1|0,-2|1,2|2,2|2,1|2,0|2,-1|2,-2|1,-2|0,2|-1,-2|-2,-2|-2,-1|-2,0|-2,1|-2,2|-1,2",  SkillRange = 2,  AnimName = "全面型 范围2"},
{ SkillRangeType = 1,  PosTable = "0,3|-2,3|-1,3|-3,3|1,3|2,3|3,3|-3,-3|-2,-3|-1,-3|0,-3|1,-3|2,-3|3,-3|-3,0|-3,1|-3,2|-3,-1|-3,-2|3,0|3,1|3,2|3,-1|3,-2|0,-1|1,-1|1,0|1,1|0,1|-1,1|-1,0|-1,-1|0,-2|1,2|2,2|2,1|2,0|2,-1|2,-2|1,-2|0,2|-1,-2|-2,-2|-2,-1|-2,0|-2,1|-2,2|-1,2",  SkillRange = 3,  AnimName = "全面型 范围3"},
{ SkillRangeType = 2,  PosTable = "1,1|1,-1|-1,-1|-1,1",  SkillRange = 1,  AnimName = "周边型 范围1"},
{ SkillRangeType = 2,  PosTable = "1,1|1,-1|-1,-1|-1,1|2,-2|2,2|-2,-2|-2,2",  SkillRange = 2,  AnimName = "周边型 范围2"},
{ SkillRangeType = 2,  PosTable = "1,1|1,-1|-1,-1|-1,1|2,-2|2,2|-2,-2|-2,2|3,-3|3,3|-3,-3|-3,3",  SkillRange = 3,  AnimName = "周边型 范围3"},
{ SkillRangeType = 3,  PosTable = "2,-2|2,0|2,2|0,2|-2,2|-2,0|-2,-2",  SkillRange = 1,  AnimName = "悬浮型 范围1"},
{ SkillRangeType = 4,  PosTable = "1,0|0,-1|-1,0|0,1",  SkillRange = 1,  AnimName = "十字型 范围1"},
{ SkillRangeType = 4,  PosTable = "1,0|0,-1|-1,0|0,1|2,0|0,-2|-2,0|0,2",  SkillRange = 2,  AnimName = "十字型 范围2"},
{ SkillRangeType = 4,  PosTable = "1,0|0,-1|-1,0|0,1|2,0|0,-2|-2,0|0,2|3,0|0,-3|-3,0|0,3",  SkillRange = 3,  AnimName = "十字型 范围3"},
{ SkillRangeType = 5,  PosTable = "0,-1|0,1",  SkillRange = 1,  AnimName = "纵向型 范围1"},
{ SkillRangeType = 5,  PosTable = "0,-1|0,1|0,-2|0,2",  SkillRange = 2,  AnimName = "纵向型 范围2"},
{ SkillRangeType = 5,  PosTable = "0,-1|0,1|0,-2|0,2|0,3|0,-3",  SkillRange = 3,  AnimName = "纵向型 范围3"},
{ SkillRangeType = 6,  PosTable = "1,0|-1,0",  SkillRange = 1,  AnimName = "横向型 范围1"},
{ SkillRangeType = 6,  PosTable = "1,0|-1,0|2,0|-2,0",  SkillRange = 2,  AnimName = "横向型 范围2"},
{ SkillRangeType = 6,  PosTable = "1,0|-1,0|2,0|-2,0|-3,0|3,0",  SkillRange = 3,  AnimName = "横向型 范围3"}
}

ExcelConfig["SkillRange"].key = {
"SkillRangeType",
"SkillRange",
"PosTable",
"AnimName"
}