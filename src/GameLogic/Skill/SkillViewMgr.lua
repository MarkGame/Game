--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 技能视图管理器

--[[
    
]]

require "common.SkillMap"

local SkillViewMgr = class("SkillViewMgr")


function SkillViewMgr:getInstance(  )
    if self.instance == nil then
        self.instance = SkillViewMgr.new()
    end
    return self.instance
end

function SkillViewMgr:ctor()
   --存放全部技能的数组
   self.skillViewList = {}
   self:registerAllSkill()

end

--创建技能
function SkillViewMgr:createSkill(skillID)

	--根据 技能的类型 去创建 主动技能
    local data = {}
    data.skillID = skillID
    local skillView = self:getSkillViewBySkillID(data.skillID) --mtCommonSkillView().new(skillID)
    
    return skillView(data)

end

--移除技能
function SkillViewMgr:removeSkill( skillID )

end


--注册全部的技能
--目前打算，在加载进入地图的时候，去注册
function SkillViewMgr:registerAllSkill()
    for k,v in pairs(SkillMap) do
        self:registerSkillCreator({skillID = k, funcView = v.skillView})
    end
end

--将注册的技能 存放在 self.skillViewList 中
function SkillViewMgr:registerSkillCreator(data)

    self.skillViewList = self.skillViewList or {}
    local funcView = self.skillViewList[data.skillID]
    --检查一下当前技能是否存在
    if nil ~= funcView then
        print("registerSkillCreator() Failed. SkillID: " .. data.skillID)
        return
    end
    --将技能逻辑存放在数组里
    self.skillViewList[data.skillID] = data.funcView

end

--获得指定技能的 logic   一般这里是用于 专属技能的 ，探测和吞噬在commonSkillView 里面

function SkillViewMgr:getSkillViewBySkillID( skillID )
    local skillView = self.skillViewList[skillID]
    if skillView == nil then return print("skillID 不存在") end
    return skillView
end

return SkillViewMgr