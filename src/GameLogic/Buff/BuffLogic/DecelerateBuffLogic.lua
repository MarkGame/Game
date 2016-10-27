--
-- Author: HLZ
-- Date: 2016-05-18 20:21:31
-- 减速BUFF的逻辑
-- 
local DecelerateBuffLogic = class("DecelerateBuffLogic",mtCommonBuffLogic())
DecelerateBuffLogic.__index = DecelerateBuffLogic

--@brief        创建BUFF对象
--@param        
--@return       objBuff
--每次都会返回一个 new 的logic 
function DecelerateBuffLogic.createBuff(data)
    local buffLogic = DecelerateBuffLogic.new()
    buffLogic:init(data)
    return buffLogic
end

function DecelerateBuffLogic:launch(monster)
   if self.isActivation == false then 
	   if monster then 
	      --降低怪物的移速
	      self.monster = monster

        local oldVelocity = monster:getLogic():getMonsterData():getMonsterVelocity()
        
        local newVelocity = oldVelocity*self:getBuffData():getBuffValue()  --配表的扣减的百分比数值

        monster:getLogic():getMonsterData():setMonsterVelocity(newVelocity)

        self.isActivation = true
        print("成功激活BUFF")
	   else 
	      print("目标怪兽不存在")
	   end  
   else
   	   --print("已经激活了，无需重复激活")
   end
end

--每个BUFF的 移除方法 不一样，所以单独处理
function DecelerateBuffLogic:removeBuff( )
	-- 要先把 施加的BUFF给移除掉，再移除自身
	--如果对象还存在的话，则把扣除的属性返回
	if self.monster and self.isActivation == true then 
     self.monster:getLogic():getMonsterData():initMonsterVelocity()
	end

  -- if self then 
  --    self:removeFromParent()         
  -- end  

end

return DecelerateBuffLogic