--全局的require


-----------------------------------玩家--------------------------------------
local PlayerMgr = nil;
---角色管理器
-- @function mtSkillMgr
-- @return GameLogic.Skill.SkillMgr
function mtPlayerMgr()
    if PlayerMgr == nil then
        PlayerMgr = require("GameLogic.Player.PlayerMgr"):getInstance()
    end
    return PlayerMgr
end

local PlayerBaseInfo = nil;
---角色信息
-- @function mtPlayerBaseInfo
-- @return GameLogic.Player.PlayerBase.PlayerBaseInfo
function mtPlayerBaseInfo()
    if PlayerBaseInfo == nil then
        PlayerBaseInfo = require("GameLogic.Player.PlayerBase.PlayerBaseInfo")
    end
    return PlayerBaseInfo
end

local PlayerLogic = nil;
---角色逻辑
--这里很想做 数据采集 做更加智能的对手
-- @function mtPlayerLogic
-- @return GameLogic.Player.PlayerLogic.PlayerLogic
function mtPlayerLogic()
    if PlayerLogic == nil then
        PlayerLogic = require("GameLogic.Player.PlayerLogic.PlayerLogic")
    end
    return PlayerLogic
end

local PlayerView = nil;
---角色视图
-- @function mtPlayerView
-- @return View.Player.PlayerView
function mtPlayerView()
    if PlayerView == nil then
        PlayerView = require("View.Player.PlayerView")
    end
    return PlayerView
end

-----------------------------------技能--------------------------------------
local SkillMgr = nil;
---技能管理器
-- @function mtSkillMgr
-- @return GameLogic.Skill.SkillMgr
function mtSkillMgr()
    if SkillMgr == nil then
        SkillMgr = require("GameLogic.Skill.SkillMgr"):getInstance()
	end
    return SkillMgr
end

--是否有存在的意义？
--有
local SkillViewMgr = nil
--- 技能视图管理器
-- @function mtSkillViewMgr
-- @return GameLogic.Skill.SkillViewMgr
function mtSkillViewMgr()
    if SkillViewMgr == nil then
        SkillViewMgr = require("GameLogic.Skill.SkillViewMgr")
	end
    return SkillViewMgr
end

local CommonSkillLogic = nil
--- 主动技能通用逻辑
-- @function mtCommonSkillLogic
-- @return GameLogic.Skill.SkillLogic.CommonSkillLogic
function mtCommonSkillLogic()
    if CommonSkillLogic == nil then
        CommonSkillLogic = require("GameLogic.Skill.SkillLogic.CommonSkillLogic")
	end
    return CommonSkillLogic
end


local SkillBaseInfo = nil
--- 主动技能信息
-- @function mtSkillBaseInfo
-- @return GameLogic.Skill.SkillBase.SkillBaseInfo
function mtSkillBaseInfo()
    if SkillBaseInfo == nil then
        SkillBaseInfo = require("GameLogic.Skill.SkillBase.SkillBaseInfo")
	end
    return SkillBaseInfo
end


local SkillDetect = nil
--- 探测逻辑
-- @function mtSkillBaseInfo
-- @return GameLogic.Skill.SkillDetect
function mtSkillDetect()
    if SkillDetect == nil then
        SkillDetect = require("GameLogic.Skill.SkillDetect")
	end
    return SkillDetect
end

local CommonSkillView = nil
--- 公用技能视图
-- @function mtCommonSkillView
-- @return View.SkillView.CommonSkillView
function mtCommonSkillView()
    if CommonSkillView == nil then
        CommonSkillView = require("View.SkillView.CommonSkillView")
    end
    return CommonSkillView
end

-----------------------------------BUFF--------------------------------------
local BuffMgr = nil;
---BUFF管理器
-- @function mtBuffMgr
-- @return GameLogic.Buff.BuffMgr
function mtBuffMgr()
    if BuffMgr == nil then
        BuffMgr = require("GameLogic.Buff.BuffMgr"):getInstance()
    end
    return BuffMgr
end

local CommonBuffLogic = nil;
---BUFF通用逻辑
-- @function mtCommonBuffLogic
-- @return GameLogic.Buff.BuffLogic.CommonBuffLogic
function mtCommonBuffLogic()
    if CommonBuffLogic == nil then
        CommonBuffLogic = require("GameLogic.Buff.BuffLogic.CommonBuffLogic")
    end
    return CommonBuffLogic
end

local BuffBaseInfo = nil;
---BUFF管理器
-- @function mtBuffBaseInfo
-- @return GameLogic.Buff.BuffBase.BuffBaseInfo
function mtBuffBaseInfo()
    if BuffBaseInfo == nil then
        BuffBaseInfo = require("GameLogic.Buff.BuffBase.BuffBaseInfo")
    end
    return BuffBaseInfo
end

-----------------------------------战斗--------------------------------------

local BattleMgr = nil
--- 战斗管理
-- @function mtBattleMgr
-- @return GameLogic.Battle.BattleMgr
function mtBattleMgr()
    if BattleMgr == nil then
        BattleMgr = require("GameLogic.Battle.BattleMgr"):getInstance()
	end
    return BattleMgr
end


local BattleBaseInfo = nil
--- 战场基本结构体
-- @function mtBattleBaseInfo
-- @return GameLogic.Battle.BattleBase.BattleBaseInfo
function mtBattleBaseInfo()
    if BattleBaseInfo == nil then
        BattleBaseInfo = require("GameLogic.Battle.BattleBase.BattleBaseInfo")
    end
    return BattleBaseInfo
end

local BehaviorLogInfo = nil
--- 行为日志
-- @function mtBehaviorLogInfo
-- @return GameLogic.Battle.BattleBase.BehaviorLogInfo
function mtBehaviorLogInfo()
    if BehaviorLogInfo == nil then
        BehaviorLogInfo = require("GameLogic.Battle.BattleBase.BehaviorLogInfo")
    end
    return BehaviorLogInfo
end


-------------------------------------孵化器---------------------------------

local HatcheryMgr = nil
--- 孵化器管理
-- @function mtHatcheryMgr
-- @return GameLogic.Hatchery.HatcheryMgr
function mtHatcheryMgr()
    if HatcheryMgr == nil then
        HatcheryMgr = require("GameLogic.Hatchery.HatcheryMgr"):getInstance()
	end
    return HatcheryMgr
end



local CommonHatcheryLogic = nil
--- 孵化器逻辑
-- @function mtCommonHatcheryLogic
-- @return GameLogic.HatcheryLogic.CommonHatcheryLogic
function mtCommonHatcheryLogic()
    if CommonHatcheryLogic == nil then
        CommonHatcheryLogic = require("GameLogic.Hatchery.HatcheryLogic.CommonHatcheryLogic")
	end
    return CommonHatcheryLogic
end

local HatcheryBaseInfo = nil
--- 孵化器逻辑
-- @function mtHatcheryBaseInfo
-- @return GameLogic.HatcheryBase.HatcheryBaseInfo
function mtHatcheryBaseInfo()
    if HatcheryBaseInfo == nil then
        HatcheryBaseInfo = require("GameLogic.Hatchery.HatcheryBase.HatcheryBaseInfo")
    end
    return HatcheryBaseInfo
end


local HatcheryView = nil
--- 孵化器视图
-- @function mtHatcheryView
-- @return View.Hatchery.HatcheryView
function mtHatcheryView()
    if HatcheryView == nil then
        HatcheryView = require("View.Hatchery.HatcheryView")
	end
    return HatcheryView
end

----------------------------------世界树----------------------------
local YggdrasilMgr = nil
--- 世界树管理
-- @function mtYggdrasilMgr
-- @return GameLogic.Yggdrasil.YggdrasilMgr
function mtYggdrasilMgr()
    if YggdrasilMgr == nil then
        YggdrasilMgr = require("GameLogic.Yggdrasil.YggdrasilMgr"):getInstance()
    end
    return YggdrasilMgr
end

local YggdrasilLogic = nil
--- 世界树逻辑
-- @function mtYggdrasilLogic
-- @return GameLogic.Yggdrasil.YggdrasilLogic
function mtYggdrasilLogic()
    if YggdrasilLogic == nil then
        YggdrasilLogic = require("GameLogic.Yggdrasil.YggdrasilLogic")
    end
    return YggdrasilLogic
end

local YggdrasilBaseInfo = nil
--- 世界树基础数据
-- @function mtYggdrasilBaseInfo
-- @return GameLogic.HatcheryBase.YggdrasilBaseInfo
function mtYggdrasilBaseInfo()
    if YggdrasilBaseInfo == nil then
        YggdrasilBaseInfo = require("GameLogic.Yggdrasil.YggdrasilBase.YggdrasilBaseInfo")
    end
    return YggdrasilBaseInfo
end


local YggdrasilView = nil
--- 世界树视图
-- @function mtYggdrasilView
-- @return View.Yggdrasil.YggdrasilView
function mtYggdrasilView()
    if YggdrasilView == nil then
        YggdrasilView = require("View.Yggdrasil.YggdrasilView")
    end
    return YggdrasilView
end


----------------------------------怪兽------------------------------
local MonsterMgr = nil
--- 怪兽管理
-- @function mtMonsterMgr
-- @return GameLogic.Monster.MonsterMgr
function mtMonsterMgr()
    if MonsterMgr == nil then
        MonsterMgr = require("GameLogic.Monster.MonsterMgr"):getInstance()
	end
    return MonsterMgr
end

local CommonMonsterLogic = nil
--- 怪兽逻辑
-- @function mtCommonMonsterLogic
-- @return GameLogic.Monster.MonsterLogic.CommonMonsterLogic
function mtCommonMonsterLogic()
    if CommonMonsterLogic == nil then
        CommonMonsterLogic = require("GameLogic.Monster.MonsterLogic.CommonMonsterLogic")
	end
    return CommonMonsterLogic
end

local MonsterView = nil
--- 怪兽视图
-- @function mtMonsterView
-- @return View.Monster.MonsterView
function mtMonsterView()
    if MonsterView == nil then
        MonsterView = require("View.Monster.MonsterView")
	end
    return MonsterView
end

local MonsterBaseInfo = nil
--- 怪兽数据结构
-- @function mtMonsterBaseInfo
-- @return GameLogic.Monster.MonsterBase.MonsterBaseInfo
function mtMonsterBaseInfo()
    if MonsterBaseInfo == nil then
        MonsterBaseInfo = require("GameLogic.Monster.MonsterBase.MonsterBaseInfo")
	end
    return MonsterBaseInfo
end

----------------------------------BUFF-----------------------------------
local BuffMgr = nil
--- BUFF管理
-- @function mtBuffMgr
-- @return GameLogic.Buff.BuffMgr
function mtBuffMgr()
    if BuffMgr == nil then
        BuffMgr = require("GameLogic.Buff.BuffMgr"):getInstance()
    end
    return BuffMgr
end

local CommonBuffLogic = nil
--- BUFF逻辑
-- @function mtCommonBuffLogic
-- @return GameLogic.Buff.BuffLogic.CommonBuffLogic
function mtCommonBuffLogic()
    if CommonBuffLogic == nil then
        CommonBuffLogic = require("GameLogic.Buff.BuffLogic.CommonBuffLogic")
    end
    return CommonBuffLogic
end

----------------------------------功能插件------------------------------------
local Queue = nil
--- 队列管理
-- @function mtQueue
-- @return common.Queue
function mtQueue()
    if Queue == nil then
        Queue = require("common.Queue")
    end
    return Queue
end

local TimeMgr = nil
--- 时间管理
-- @function mtTimeMgr
-- @return Utils.TimeMgr
function mtTimeMgr()
    if TimeMgr == nil then
        TimeMgr = require("Utils.TimeMgr"):getInstance()
    end
    return TimeMgr
end


local SchedulerMgr = nil
--- 统一调度器管理
-- @function SchedulerMgr
-- @return Utils.SchedulerMgr
function mtSchedulerMgr()
    if SchedulerMgr == nil then
        SchedulerMgr = require("GameLogic.Common.SchedulerMgr"):getInstance()
    end
    return SchedulerMgr
end

local EventDispatch = nil
--- 事件管理
-- @function mtEventDispatch
-- @return Utils.EventDispatch
function mtEventDispatch()
    if EventDispatch == nil then
        EventDispatch = require("Utils.EventDispatch"):getInstance()
    end
    return EventDispatch
end


local StateMachine = nil
--- 状态机
-- @function mtStateMachine
-- @return Utils.StateMachine
function mtStateMachine()
    if StateMachine == nil then
        StateMachine = require("common.StateMachine")
    end
    return StateMachine
end

local HRocker = nil
--- 虚拟摇杆
-- @function mtHRocker
-- @return Utils.HRocker
function mtHRocker()
    if HRocker == nil then
        HRocker = require("Utils.HRocker")
    end
    return HRocker
end

local BehaviorLogView = nil
--- 行为日志输出
-- @function mtBehaviorLogView
-- @return View.Widget.BehaviorLogView
function mtBehaviorLogView()
    if BehaviorLogView == nil then
        BehaviorLogView = require("View.Widget.BehaviorLogView")
    end
    return BehaviorLogView
end


local FntNormal = nil
--- 字体
-- @function mtFntNormal
-- @return Utils.FntNormal
function mtFntNormal()
    if FntNormal == nil then
        FntNormal = require("Utils.Font")
    end
    return FntNormal
end


local TextManager = nil
--- 字体
-- @function mtTextManager
-- @return Utils.TextManager
function mtTextManager()
    if TextManager == nil then
        TextManager = require("common.TextManager")
    end
    return TextManager
end

local FloatMsgMgr = nil
---字体消息管理
-- @function mtFloatMsgMgr
-- @return Utils.FloatMsgMgr
function mtFloatMsgMgr()
    if FloatMsgMgr == nil then
        FloatMsgMgr = require("Utils.FloatMsgMgr")
    end
    return FloatMsgMgr
end

-- local Game = nil
-- --- 游戏管理
-- -- @function mtGame
-- -- @return GameLogic.Game
-- function mtGame()
--     if Game == nil then
--         Game = require("GameLogic.Game"):getInstance()
--     end
--     return Game
-- end

-- local ResManager = nil 
-- --- UI资源管理
-- -- @function mtGame
-- -- @return GameLogic.Game
-- function mtResManager()
--     if ResManager == nil then
--         ResManager = require("Framework.ResManager.ResManager"):getInstance()
--     end
--     return ResManager
-- end

---------------------------------------封装节点------------------------------------

local EventNode = nil 
--- 事件节点
-- @function mtEventNode
-- @return GameLogic.EventNode
function mtEventNode()
    if EventNode == nil then
        EventNode = require("View.BaseNode.EventNode")
    end
    return EventNode
end

local PlayerNode = nil 
--- 战斗场景节点
-- @function mtPlayerNode
-- @return GameLogic.BattleScene
function mtPlayerNode()
    if PlayerNode == nil then
        PlayerNode = require("View.BaseNode.PlayerNode")
    end
    return PlayerNode
end

local MonsterNode = nil 
--- 战斗场景节点
-- @function mtMonsterNode
-- @return GameLogic.MonsterNode
function mtMonsterNode()
    if MonsterNode == nil then
        MonsterNode = require("View.BaseNode.MonsterNode")
    end
    return MonsterNode
end

local BuildNode = nil 
--- 战斗场景节点
-- @function BuildNode
-- @return GameLogic.BuildNode
function mtBuildNode()
    if BuildNode == nil then
        BuildNode = require("View.BaseNode.BuildNode")
    end
    return BuildNode
end

local BattleScene = nil 
--- 战斗场景节点
-- @function mtBattleScene
-- @return GameLogic.BattleScene
function mtBattleScene()
    if BattleScene == nil then
        BattleScene = require("View.BaseNode.BattleScene")
    end
    return BattleScene
end

local EventScene = nil 
--- 事件场景节点
-- @function mtEventScene
-- @return GameLogic.EventScene
function mtEventScene()
    if EventScene == nil then
        EventScene = require("View.BaseNode.EventScene")
    end
    return EventScene
end

local TouchLayer = nil 
--- 点击场景节点
-- @function mtTouchLayer
-- @return GameLogic.TouchLayer
function mtTouchLayer()
    if TouchLayer == nil then
        TouchLayer = require("View.BaseNode.TouchLayer")
    end
    return TouchLayer
end


local SkillNode = nil 
--- 点击场景节点
-- @function mtSkillNode
-- @return View.BaseNode.SkillNode
function mtSkillNode()
    if SkillNode == nil then
        SkillNode = require("View.BaseNode.SkillNode")
    end
    return SkillNode
end


