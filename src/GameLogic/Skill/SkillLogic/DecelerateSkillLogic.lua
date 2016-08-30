--
-- Author: HLZ
-- Date: 2016-05-18 20:21:31
-- 减速技能的逻辑
-- 
local DecelerateSkillLogic = class("DecelerateSkillLogic",mtCommonSkillLogic())
DecelerateSkillLogic.__index = DecelerateSkillLogic

--@brief        创建技能对象
--@param        {skillID = xxx, level = xxx, heroSeq = xxx}
--@return       objSkill
function DecelerateSkillLogic.createSkill(data)
    local skillLogic = DecelerateSkillLogic.new()
    skillLogic:init(data)
    return skillLogic
end

--单独逻辑
--monster 释放技能本身
--index 对应流动技能序号 没有可以不填（普通怪兽不需要）
function DecelerateSkillLogic:launch(monster,index)
   self:showSkillRangeDiagram(monster)
   if monster ~= nil then 
      self:setOwner(monster)
      local targetMonster = self:getTargetMonster(monster)
     
      if targetMonster then
         --给目标附加 技能指定的BUFF  
         local buffID = self:getSkillData():getSkillBuffID()
         local buff = mtBuffMgr():createBuff(buffID)
         if buff ~= nil then
            self.buff = buff 
            targetMonster:getLogic():addBuffToBuffList(buff)
         end
         if self:isDisposableSkill() == true then 
            self:hideSkillRangeDiagram(monster)
            self:removeSkill(index)
         else
            print("不是一次性技能，需要在特定的地方去移除技能，不自动删除")
            self:hideSkillRangeDiagram(monster)
         end
      else 
         print("目标怪兽不存在")
         --不存在目标的话，技能是否需要消耗掉？
      end
   end

   
end

function DecelerateSkillLogic:removeSkill(index)
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

return DecelerateSkillLogic