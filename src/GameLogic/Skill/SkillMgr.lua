--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 技能信息管理器

--[[
    这里的每个技能最好可以模块化，并做到 随时调用的效果
    技能需要有两种： 主动技能 和 被动技能 

]]
require "Utils.Config.SkillMap"

local SkillMgr = class("SkillMgr")


function SkillMgr:getInstance(  )
    if self.instance == nil then
        self.instance = SkillMgr.new()
    end
    return self.instance
end

function SkillMgr:ctor()
   --存放全部技能的数组
   self.skillLogicList = {}
   self:registerAllSkill()

end

--创建技能
function SkillMgr:createSkill(skillID)

	--根据 技能的类型 去创建 主动技能
    local data = {}
    data.skillID = skillID
    local skillLogic = self:getSkillLogicBySkillID(data.skillID) --mtCommonSkillLogic().new(skillID)
    
    return skillLogic(data)

end

--移除技能
function SkillMgr:removeSkill( skillID )

end


--注册全部的技能
--目前打算，在加载进入地图的时候，去注册
function SkillMgr:registerAllSkill()
    for k,v in pairs(SkillMap) do
        self:registerSkillCreator({skillID = k, funcLogic = v.skillLogic})
    end
end

--将注册的技能 存放在 self.skillLogicList 中
function SkillMgr:registerSkillCreator(data)

    self.skillLogicList = self.skillLogicList or {}
    local funcLogic = self.skillLogicList[data.skillID]
    --检查一下当前技能是否存在
    if nil ~= funcLogic then
        print("registerSkillCreator() Failed. SkillID: " .. data.skillID)
        return
    end
    --将技能逻辑存放在数组里
    self.skillLogicList[data.skillID] = data.funcLogic

end

--获得指定技能的 logic   一般这里是用于 专属技能的 ，探测和吞噬在commonSkillLogic 里面

function SkillMgr:getSkillLogicBySkillID( skillID )
    local skillLogic = self.skillLogicList[skillID]
    if skillLogic == nil then return print("skillID 不存在") end
    return skillLogic
end

return SkillMgr