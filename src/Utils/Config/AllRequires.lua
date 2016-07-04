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
-- @return Utils.Queue
function mtQueue()
    if Queue == nil then
        Queue = require("Utils.Queue")
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
        SchedulerMgr = require("Utils.SchedulerMgr"):getInstance()
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
        StateMachine = require("Utils.StateMachine")
    end
    return StateMachine
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

-- local BattleScene = nil 
-- --- 战斗场景节点
-- -- @function mtBattleScene
-- -- @return GameLogic.BattleScene
-- function mtBattleScene()
--     if BattleScene == nil then
--         BattleScene = require("View.BaseNode.BattleScene")
--     end
--     return BattleScene
-- end
