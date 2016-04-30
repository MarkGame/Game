--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 技能视图管理器

--[[
    
]]

SkillViewMgr = class("SkillViewMgr")
SkillViewMgr.__index = SkillViewMgr

function SkillViewMgr:getInstance(  )
    if self.instance == nil then
        self.instance = SkillViewMgr.new()
    end
    return self.instance
end

function SkillViewMgr:ctor()

end