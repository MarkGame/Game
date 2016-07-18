--
-- Author: HLZ
-- Date: 2016-07-14 19:52:13
-- 虚拟摇杆控件

local HRocker = class("HRocker",mtTouchLayer() )

function HRocker:ctor()
    HRocker.super.ctor(self)
    -- 用于标识摇杆与摇杆的背景
	self.tagForHRocker = {
		tag_rocker = 0, 
		tag_rockerBG = 1
	}

		-- 用于标识摇杆方向 8 方向 
	self.tagDirecton = {
		rocker_stay = 0,
		rocker_right = 1,
		rocker_up = 2,
		rocker_left = 3,
		rocker_down = 4,
		rocker_left_up = 5,
		rocker_left_down = 6,
		rocker_right_up = 7,
		rocker_right_down = 8
	}


	-- 判断控制杆方向，用来判断精灵上、下、左、右运动
	self.rocketDirection = nil
	-- 当前人物行走方向,用来判断精灵的朝向，精灵脸朝右还是朝左
	self.rocketRun = false
	-- 是否可操作摇杆
	self.isCanMove = false
	-- 摇杆背景的坐标
	self.rockerBGPosition = nil
	-- const PI
	self.PI = 3.1415

end

-- 创建摇杆(摇杆的操作题图片资源名，摇杆背景图片资源名，起始坐标)
function HRocker:createHRocker( rockerImageName, rockerBGImageName, position )

	local layer = HRocker.new()
	if layer then
		-- 1 按钮， 2 背景
		layer:rockerInit(rockerImageName, rockerBGImageName, position)
		return layer
	end
    return nil

end

-- privete 
-- 自定义初始化函数 ， 1 按钮，  2 背景图
function HRocker:rockerInit( rockerImageName, rockerBGImageName, position )

	local spRockerBG = ccui.ImageView:create(rockerBGImageName)
	spRockerBG:setPosition( position )
	self:addChild(spRockerBG, 0, self.tagForHRocker.tag_rockerBG)
	spRockerBG:setVisible(false)
	local spRocker = ccui.ImageView:create(rockerImageName)
	spRocker:setPosition( position )
	self:addChild(spRocker, 1, self.tagForHRocker.tag_rocker)
	spRocker:setVisible(false)

	self.rockerBGPosition = position
	--控制 最远滚轴范围
	self.rockerBGR = spRockerBG:getContentSize().width * 0.5

	-- 表示摇杆方向不变
	self.rocketDirection = self.tagDirecton.rocker_stay

end

-- 启动摇杆(显示摇杆、监听摇杆触屏事件)
function HRocker:startRocker( _isStopOther )
  
  local rocker = self:getChildByTag(self.tagForHRocker.tag_rocker)
  rocker:setVisible(true)
  local rockerBG = self:getChildByTag(self.tagForHRocker.tag_rockerBG)
  rockerBG:setVisible(true)
  -- 这里开启了点击事件
  self:setTouchEnabled(true)
  --bSwallow:是否吞并触摸节点(默认false),设为true后,将不会派发触摸点到子节点
  self:initTouchListener(false)


  self.battleScene = mtBattleMgr():getScene()

end

-- 停止摇杆（隐藏摇杆， 取消摇杆的触屏监听）
function HRocker:stopRocker()

	local rocker = self:getChildByTag(self.tagForHRocker.tag_rocker)
	rocker:setVisible(false)
	local rockerBG = self:getChildByTag(self.tagForHRocker.tag_rockerBG)
	rockerBG:setVisible(false)
	-- 这里移除了点击事件
	self:removeTouchListener()

end

-- 获取当前摇杆与用户触屏点的角度
function HRocker:getRad( pos1, pos2 )

	local px1 = pos1.x
	local py1 = pos1.y

	local px2 = pos2.x
	local py2 = pos2.y

	-- 得到两点x的距离
	local x = px2 - px1
	-- 得到两点y的距离 
	local y = py1 - py2
	-- 算出斜边的长度
	local xie = math.sqrt(math.pow(x, 2) + math.pow(y, 2))
	-- 得到这个角度的余弦值（通过三角函数中的定里：角度余弦值 ＝ 斜边/斜边
	local cosAngle = x / xie
	-- 通过反余弦定理获取到期角度的弧度
	local rad = math.acos(cosAngle)
	-- 注意：当触屏的位置Y坐标<摇杆的Y坐标，我们要去反值-0~-180
	if py2 < py1 then
	   rad = -rad
	end

	return rad
end

function HRocker:getAngelePosition( r, angle )
	-- ccp( r *      cos( angle ), r *      sin(angle));
	return cc.p( r * math.cos( angle ), r * math.sin(angle))
end

-- 抬起事件
function HRocker:onTouchBegan( x,y )

	local point = cc.p(x,y)
	local rocker = self:getChildByTag(self.tagForHRocker.tag_rocker)
	if cc.rectContainsPoint(rocker:getBoundingBox(), point) then
    	self.isCanMove = true
	end

	return true
end

-- 移动事件
function HRocker:onTouchMoved( x,y )

	if not self.isCanMove then
	   return
	end
	local point = cc.p(x,y)
	local rocker = self:getChildByTag(self.tagForHRocker.tag_rocker)
	-- 得到摇杆与触屏点所形成的角度
	local angle = self:getRad(self.rockerBGPosition, point)
	-- 两个圆的圆心距
	local kf = math.sqrt(math.pow( self.rockerBGPosition.x - point.x, 2) + math.pow( self.rockerBGPosition.y - point.y, 2))
	-- 判断两个圆的圆心距是否大于摇杆背景的半径
	if kf >= self.rockerBGR then
		-- 保证内部小圆运动的长度限制
		rocker:setPosition(cc.pAdd(self:getAngelePosition(self.rockerBGR, angle), cc.p(self.rockerBGPosition.x, self.rockerBGPosition.y)))
	else
		-- 当没有超过，让摇杆跟随用户触屏点移动即可
		rocker:setPosition(point)
    end

	local rockerBG = self:getChildByTag(self.tagForHRocker.tag_rockerBG)
	local p_dian = {x = rockerBG:getPositionX(), y = rockerBG:getPositionY()}

	local move_x = p_dian.x - point.x
	local move_y = p_dian.y - point.y

	-- printf("movex == %f, movey == %f", move_x, move_y)
    -- 八个方向
	-- if move_x >= 10 and move_y <= -10 then
	-- 	--左上
	-- 	self.rocketDirection = self.tagDirecton.rocker_left_up
	-- 	print("左上")
	-- 	self.rocketRun = true
	-- elseif move_x >= 10 and move_y >= 10 then
	-- 	-- 左下
	-- 	self.rocketDirection = self.tagDirecton.rocker_left_down
	-- 	print("左下")
	-- 	self.rocketRun = true
	-- elseif move_x <= -10 and move_y <= -10 then
	-- 	-- 右上
	-- 	self.rocketDirection = self.tagDirecton.rocker_right_up
	-- 	print("右上")
	-- 	self.rocketRun = false
	-- elseif move_x <= -10 and move_y >= 10 then
	-- 	-- 右下
	-- 	self.rocketDirection = self.tagDirecton.rocker_right_down
	-- 	print("右下")
	-- 	self.rocketRun = false
	-- elseif move_x > -10 and move_x < 10 and move_y > 0 then
	-- 	-- 下
	-- 	self.rocketDirection = self.tagDirecton.rocker_down
	-- 	print("下")
	-- elseif move_x > -10 and move_x < 10 and move_y < 0 then
	-- 	-- 上
	-- 	self.rocketDirection = self.tagDirecton.rocker_up
	-- 	print("上")
	-- elseif move_x > 0 and move_y > -10 and move_y < 10 then
	-- 	-- 左
	-- 	self.rocketDirection = self.tagDirecton.rocker_left
	-- 	print("左")
	-- 	self.rocketRun = true
	-- elseif move_x < 0 and move_y > -10 and move_y < 10 then
	-- 	-- 右
	-- 	self.rocketDirection = self.tagDirecton.rocker_right
	-- 	print("右")
	-- 	self.rocketRun = false
 --    end


    -- 判断四个方向
	if angle >= -self.PI/4 and angle < self.PI/4 then
		 self:changeDirection(self.tagDirecton.rocker_right)
	elseif angle >= self.PI/4 and angle < 3 * self.PI/4 then
		 self:changeDirection(self.tagDirecton.rocker_up)
	elseif (angle >= (3 * self.PI/4) and angle <= self.PI) or (angle >= -self.PI and angle < (-3 * self.PI/4) ) then
		 self:changeDirection(self.tagDirecton.rocker_left)
	elseif angle >= -3 * self.PI/4 and angle < -self.PI/4 then
		 self:changeDirection(self.tagDirecton.rocker_down)
	end
end


-- 离开事件
function HRocker:onTouchEnded( x,y )

	if not self.isCanMove then
	   return
	end

	local rockerBG = self:getChildByTag(self.tagForHRocker.tag_rockerBG)
	local rocker = self:getChildByTag(self.tagForHRocker.tag_rocker)
	rocker:stopAllActions()
	rocker:runAction(cc.MoveTo:create(0.08,cc.p(rockerBG:getPositionX(),rockerBG:getPositionY()))) 
	self.isCanMove = false
	self:changeDirection(self.tagDirecton.rocker_stay)

end

--改变当前的方向
function HRocker:changeDirection( direction )

	switch(direction) : caseof
    {
     [self.tagDirecton.rocker_stay]  = function()   -- 向移动
          if self.rocketDirection ~= self.tagDirecton.rocker_stay then 
             self:stopMoveByDirection(self.rocketDirection)
             self.rocketDirection = self.tagDirecton.rocker_stay
          end
      end,
     [self.tagDirecton.rocker_right] = function()   -- 向右移动
          if self.rocketDirection ~= self.tagDirecton.rocker_right then 
             self.battleScene:pressedRightBtnListener()
             self:stopMoveByDirection(self.rocketDirection)
             self.rocketDirection = self.tagDirecton.rocker_right
          end
      end,
     [self.tagDirecton.rocker_up]    = function()   -- 向上移动
          if self.rocketDirection ~= self.tagDirecton.rocker_up then 
             self.battleScene:pressedUpBtnListener()
             self:stopMoveByDirection(self.rocketDirection)
             self.rocketDirection = self.tagDirecton.rocker_up
          end
      end,
     [self.tagDirecton.rocker_left]  = function()   -- 向左移动
          if self.rocketDirection ~= self.tagDirecton.rocker_left then 
             self.battleScene:pressedLeftBtnListener()
             self:stopMoveByDirection(self.rocketDirection)
             self.rocketDirection = self.tagDirecton.rocker_left
          end
     end, 
     [self.tagDirecton.rocker_down]  = function()   -- 向下移动
          if self.rocketDirection ~= self.tagDirecton.rocker_down then 
             self.battleScene:pressedDownBtnListener()
             self:stopMoveByDirection(self.rocketDirection)
             self.rocketDirection = self.tagDirecton.rocker_down
          end
     end, 
    }
end

--根据方向停止移动
function HRocker:stopMoveByDirection( direction )

	if direction == self.tagDirecton.rocker_right then 
        self.battleScene:releasedRightBtnListener()
	elseif direction == self.tagDirecton.rocker_up then
		self.battleScene:releasedUpBtnListener()
	elseif direction == self.tagDirecton.rocker_left then
		self.battleScene:releasedLeftBtnListener()
	elseif direction == self.tagDirecton.rocker_down then
		self.battleScene:releasedDownBtnListener()
	end
end



function HRocker:onExit(  )
	HRocker.super.onExit(self)
end

return HRocker

--下面是摇杆的调用：

-- 添加摇杆 第一张图是按钮， 第二张图是背影


-- self.rocker = HRocker:createHRocker("Direction_bt.png", "Direction_bc.png", cc.p(100, 100))
--    self:addChild(self.rocker)
--    self.rocker:startRocker(true)