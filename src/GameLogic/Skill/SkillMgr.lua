--
-- Author: HLZ
-- Date: 2016-04-22 16:52:31
-- 技能信息管理器

--[[
    这里的每个技能最好可以模块化，并做到 随时调用的效果
    技能需要有两种： 主动技能 和 被动技能 

]]

local SkillMgr = class("SkillMgr")


function SkillMgr:getInstance(  )
    if self.instance == nil then
        self.instance = SkillMgr.new()
    end
    return self.instance
end

function SkillMgr:ctor()

end

--创建技能
function SkillMgr:createSkill(skillID)

	--根据 技能的类型 去创建 主动技能 或者 被动技能 ？ 还是不要被动技能了  
    
    local skillLogic = mtCommonSkillLogic().new(skillID)
    
    return skillLogic

end

--移除技能
function SkillMgr:removeSkill( skill )
	

end

return SkillMgr