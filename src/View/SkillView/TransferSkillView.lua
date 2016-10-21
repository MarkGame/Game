--
-- Author: HLZ
-- Date: 2016-05-19 19:31:00
-- 传送技能的视图
-- 
local TransferSkillView = class("TransferSkillView",mtCommonSkillView())
TransferSkillView.__index            = TransferSkillView

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function TransferSkillView.createSkill(data)
    local skillView = TransferSkillView.new()
    skillView:init(data)
    return skillView
end

function TransferSkillView:launch()


end

return TransferSkillView