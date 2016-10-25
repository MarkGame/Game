--
-- Author: HLZ
-- Date: 2016-06-29 20:21:31
-- 加速BUFF的逻辑
-- 
local AccelerateBuffLogic = class("AccelerateBuffLogic",mtCommonBuffLogic())
AccelerateBuffLogic.__index = AccelerateBuffLogic

--@brief        创建BUFF对象
--@param        
--@return       objBuff
--每次都会返回一个 new 的logic 
function AccelerateBuffLogic.createBuff(data)
    local buffLogic = AccelerateBuffLogic.new()
    buffLogic:init(data)
    return buffLogic
end

function AccelerateBuffLogic:launch(monster)
   if self.isActivation == false then 
	   if monster then 
	      --降低怪物的移速
	      self.monster = monster

          local oldVelocity = monster:getLogic():getMonsterData():getMonsterVelocity()
          
          local newVelocity = oldVelocity*self:getBuffData():getBuffValue()  --配表的加速的百分比数值
 
          monster:getLogic():getMonsterData():setMonsterVelocity(newVelocity)

          self.isActivation = true
	   else 
	      print("目标怪兽不存在")
	   end  
   else
   	   print("已经激活了，无需重复激活")
   end
end

--每个BUFF的 移除方法 不一样，所以单独处理
function AccelerateBuffLogic:removeBuff( )
	-- 要先把 施加的BUFF给移除掉，再移除自身
	--如果对象还存在的话，则把扣除的属性返回
	if self.monster and self.isActivation == true then 
     self.monster:getLogic():getMonsterData():initMonsterVelocity()
	end

	g_Worker:pushDelayQueue(function()
     if self then 
        self:removeFromParent()       
     end
  end)
end

return AccelerateBuffLogic