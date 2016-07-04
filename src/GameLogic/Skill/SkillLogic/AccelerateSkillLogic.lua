--
-- Author: HLZ
-- Date: 2016-05-18 20:22:31
-- 加速技能的逻辑
-- 
local AccelerateSkillLogic = class("AccelerateSkillLogic",mtCommonSkillLogic())
AccelerateSkillLogic.__index            = AccelerateSkillLogic

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function AccelerateSkillLogic.createSkill(data)
    local skillLogic = AccelerateSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--单独逻辑
--加速是对自己使用的
function AccelerateSkillLogic:launch(monster,index) 
    if monster then
       --给目标附加 技能指定的BUFF  
       self:setOwner(monster)
       local buffID = self:getSkillData():getSkillBuffID()
       local buff = mtBuffMgr():createBuff(buffID)
       if buff ~= nil then
          self.buff = buff 
          monster:getLogic():addBuffToBuffList(buff)
       end
       if self:isDisposableSkill() == true then 
          self:removeSkill(index)
       else
          print("不是一次性技能，需要在特定的地方去移除技能，不自动删除")
       end
    else 
       print("自身怪兽不存在")
       --不存在目标的话，技能是否需要消耗掉？
    end
   
end

function AccelerateSkillLogic:removeSkill( )
    --从玩家身上移除
    if index ~= nil then 
       if self.owner ~= nil then 
          --从拥有者的流动技能队列中删除 再本身删除
          self.owner:getLogic():deleSkillFromFlowSkillsList(index)
          g_Worker:pushDelayQueue(function()
             self:removeFromParent()           
          end)
       end
    else --普通怪兽的移除
       g_Worker:pushDelayQueue(function()
          self:removeFromParent()           
       end)
    end
end


return AccelerateSkillLogic

