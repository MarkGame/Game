ExcelConfig = ExcelConfig or {}
ExcelConfig["Buff"] = {}
ExcelConfig["Buff"].list = {
{ Name = "低级减速",  Value = 0.8,  Time = 3,  Type = 1,  ID = 1001,  Desc = "移动速度降低"},
{ Name = "中级减速",  Value = 0.6,  Time = 3,  Type = 1,  ID = 1002,  Desc = "移动速度降低"},
{ Name = "高级减速",  Value = 0.4,  Time = 3,  Type = 1,  ID = 1003,  Desc = "移动速度降低"},
{ Name = "低级加速",  Value = 0.8,  Time = 3,  Type = 2,  ID = 1004,  Desc = "移动速度提高"},
{ Name = "中级加速",  Value = 0.6,  Time = 3,  Type = 2,  ID = 1005,  Desc = "移动速度提高"},
{ Name = "高级加速",  Value = 0.4,  Time = 3,  Type = 2,  ID = 1006,  Desc = "移动速度提高"},
{ Name = "低级禁锢",  Value = 0.8,  Time = 1,  Type = 3,  ID = 1007,  Desc = "无法行走"},
{ Name = "中级禁锢",  Value = 0.6,  Time = 1.5,  Type = 3,  ID = 1008,  Desc = "无法行走"},
{ Name = "高级禁锢",  Value = 0.4,  Time = 2,  Type = 3,  ID = 1009,  Desc = "无法行走"},
{ Name = "低级隐身",  Value = 0.8,  Time = 5,  Type = 4,  ID = 1010,  Desc = "隐身"},
{ Name = "中级隐身",  Value = 0.6,  Time = 10,  Type = 4,  ID = 1011,  Desc = "隐身"},
{ Name = "高级隐身",  Value = 0.4,  Time = 15,  Type = 4,  ID = 1012,  Desc = "隐身"},
{ Name = "闪耀",  Value = 0.8,  Time = 10,  Type = 5,  ID = 1013,  Desc = "可以看到隐身单位"},
{ Name = "低级恐惧",  Value = 0.6,  Time = 1,  Type = 6,  ID = 1014,  Desc = "角色随机行走，无法控制"},
{ Name = "中级恐惧",  Value = 0.4,  Time = 1.5,  Type = 6,  ID = 1015,  Desc = "角色随机行走，无法控制"},
{ Name = "高级恐惧",  Value = 0.8,  Time = 2,  Type = 6,  ID = 1016,  Desc = "角色随机行走，无法控制"},
{ Name = "诅咒",  Value = 0.6,  Time = 5,  Type = 7,  ID = 1017,  Desc = "饱食度消耗增加"},
{ Name = "时停",  Value = 0.4,  Time = 1,  Type = 8,  ID = 1018,  Desc = "强制停止一切行动"}
}

ExcelConfig["Buff"].key = {
"ID",
"Name",
"Type",
"Time",
"Desc",
"Value"
}