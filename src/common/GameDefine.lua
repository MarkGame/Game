
MoveDirectionType = {
    idle  = 1,
	left  = 2,
    right = 3,
    up    = 4,
    down  = 5,
}

--TiledMap 
TiledMapLayer = {
	barrier = "Barrier",
	background = "BackGround",
}

--动作类型
AnimationType = {
	idleD = 1,
	idleL = 2,
	idleR = 3,
	idleU = 4,
	walkD = 5,
	walkL = 6, 
	walkR = 7,
	walkU = 8,
}

--战斗阶段
BattleStage = {
	init   = 0,
	level1 = 1,
	level2 = 2,
	level3 = 3,
	ended = 4,
}

--玩家类型
PlayerType = {
	player = 1,
	enemy  = 2,
}

SkillType = {
	static = 1,
	disposable  = 2,
}

MonsterBehaviorType = {
	idle         = 1 ,
	search       = 2 ,
	selectTarget = 3 ,
	autoMove     = 4 ,
	chase        = 5 ,
	escape       = 6 ,
	devour       = 7 ,
    useExclusive = 8 ,
    die          = 9 ,
}

---------------------------------------------layer TAG --------------------------------------------

-- UI root layer所有的UI都放在这个layer下面
UI_LAYER_TAG = 120336759;

--地图层
BATTLEMAP_MAP_LAYER_TAG = 850000

------------------------------------------------ UI层级 ----------------------------------------------------
ZVALUE_GUIDE        =950000;
ZVALUE_UISETTINGS   =900000;
ZVALUE_UIANIM		=800000;
ZVALUE_ROCKER       =750000;
ZVALUE_UI			=700000;
ZVALUE_WEATHER      =698000;
ZVALUE_TOUCH        =690000;

ZVALUE_WAVETIP		=600000;
ZVALUE_UNIQUESKILL_BLACKSCREEN = 550000;
ZVALUE_EFFECT		=500000;
ZVALUE_OBJECTANIM	=400000;
ZVALUE_OBJECT		=300000;
ZVALUE_LAYERANIM	=200000;
ZVALUE_LAYER_OBJ	=100000;
ZVALUE_LAYER		=1000;
 
----------------------------------------------大地图上的层级 --------------------------------------------------
ZVALUE_BATTLEMAP_BOTTOM = 0;--底层空间
ZVALUE_BATTLEMAP_TMX = 100000;--地表
ZVALUE_BATTLEMAP_TOP = 200000;--上层空间


------------------------------------------------TMX 上的层级 ---------------------------------------------------

ZVALUE_BATTLEMAP_HATCHERY = 100000 --孵化场的层级
ZVALUE_BATTLEMAP_PLAYER = 200000 --玩家的层级
ZVALUE_BATTLEMAP_MONSTER = 300000 --怪兽的层级

-------------------------------------------- TiledMap 地图文件地址 和 层级名称 ----------------------------------

ORIGINAL_SCENCE_32_TMX = "TiledMap/Hatchery.tmx"

ORIGINAL_SCENCE_64_TMX = "TiledMap/Hatchery64.tmx"