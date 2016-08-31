--
-- Author: HLZ
-- Date: 2016-07-26 15:27:00
-- 怪兽行为日志视图

--[[
    开发者使用： 观察怪兽的行为日志 
    以后这种UI 可以在其他地方使用

]]
local BehaviorLogView = class("BehaviorLogView",mtEventNode())


function BehaviorLogView:ctor()
	BehaviorLogView.super.ctor(self)

	self:initData()

	self:initGUI()

	self:initEvent()
	
end

function BehaviorLogView:initData(  )
	self.nowMonsterLogID = 0
    
    self.maxMonsterLogID = mtBattleMgr():getMonsterLogID()
end

function BehaviorLogView:initGUI(  )
	
    self.guiNode = createGUINode(res.RES_MONSTER_BEHAVIORLOG_UI)
    self.guiNode:setName("self.guiNode")
    self:addChild(self.guiNode,15)
    
    --点击其他区域 关闭界面
    self.guiNode:setTouchEnabled(true)
    self.guiNode:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
           self:onExit()
        end 
    end)

    self.btnListView = self.guiNode:getChildByName("ListView_2")
    self.btnModel = self.btnListView:getChildByName("Panel_4")

    self.btnListView:setItemModel(self.btnModel)
    self.btnListView:removeAllItems()

    self.listView = self.guiNode:getChildByName("ListView_3")
    self.listViewModel = self.listView:getChildByName("Panel_6")

    self.listView:setItemModel(self.listViewModel)
    self.listView:removeAllItems()

	self:refreshAllMonsterLogBtn()
end

function BehaviorLogView:initEvent()

    self:registerEvent(BATTLE_NEW_BEHAVIORLOG,function(event)
        if event.data.newLog ~= nil then 
           self:addNewLogToNowList(event.data.newLog)
        end
    end)

    self:registerEvent(BATTLE_NEW_BEHAVIORLOG_BTN,function(event)
        self:addNewBtnToNowBtnList()
    end)

end

--添加新的 日志按钮
function BehaviorLogView:addNewBtnToNowBtnList( )
	self.maxMonsterLogID = mtBattleMgr():getMonsterLogID()
	if self.maxMonsterLogID == self.initBtnIndex then 
       self:setLogBtnPanel()
	end
end

--横版的listView 每一个代表一个按钮
function BehaviorLogView:refreshAllMonsterLogBtn(  )

	self.btnListView:removeAllItems()
    
    self.initBtnIndex = 1

	if self.maxMonsterLogID > 0 then 

	    --分帧加载
	    local func = function()
	        if self.initBtnIndex <= self.maxMonsterLogID then

	            self:setLogBtnPanel()

	        else
	            self.schedulerBtnListHandler = mtSchedulerMgr():removeScheduler(self.schedulerBtnListHandler)
	        end
	    end

	    self.schedulerBtnListHandler = mtSchedulerMgr():removeScheduler(self.schedulerBtnListHandler)

	    self.schedulerBtnListHandler = mtSchedulerMgr():addScheduler(0,-1,func)

	end
end

--设置日志按钮
function BehaviorLogView:setLogBtnPanel()
	self.btnListView:pushBackDefaultItem()
    local panel = self.btnListView:getItem(self.initBtnIndex - 1) --从0开始

    local btn = panel:getChildByName("Button_5")
    btn.btnIndex = self.initBtnIndex
   
    btn:addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
           self:refreshLogList(sender.btnIndex)      
        end 
    end)

    self.initBtnIndex = self.initBtnIndex + 1
end


--添加新的日志到当前的列表里
function BehaviorLogView:addNewLogToNowList( log )
	if log:getMonsterLogID() == self.nowMonsterLogID and log ~= nil then 
	   local str = log:getLogStr()

       self:setBehaviorLogPanel(str)

	end
end

--竖版的listView  记录每一个怪兽的行为
--根据怪兽ID 去显示怪兽的行为日志 
--只有打开该页签的时候 会刷新一次，后面会单独往里面加
function BehaviorLogView:refreshLogList(monsterLogID)

	self.listView:removeAllItems()
	
	self.behaviorLogList = mtBattleMgr():getBehaviorLogByID(monsterLogID)
    
    self.initIndex = 1

	if self.behaviorLogList and #self.behaviorLogList > 0 then 
	    
	    local listCount = #self.behaviorLogList

	    --分帧加载
	    local func = function()
	        if self.initIndex <= listCount then
	            
	            local str = self.behaviorLogList[self.initIndex]:getLogStr()
	            self:setBehaviorLogPanel(str)
	            
	        else
	            self.schedulerListHandler = mtSchedulerMgr():removeScheduler(self.schedulerListHandler)
	        end
	    end

	    self.schedulerListHandler = mtSchedulerMgr():removeScheduler(self.schedulerListHandler)

	    self.schedulerListHandler = mtSchedulerMgr():addScheduler(0,-1,func)

	end

end

--设置行为日志
function BehaviorLogView:setBehaviorLogPanel(str)
	self.listView:pushBackDefaultItem()
    local panel = self.listView:getItem(self.initIndex - 1) --从0开始

    local text = panel:getChildByName("Label_7")
    text:setString(str)


    self.initIndex = self.initIndex + 1
end


function BehaviorLogView:onEnter()
	BehaviorLogView.super.onEnter(self)

end

function BehaviorLogView:onExit()
	BehaviorLogView.super.onExit(self)

	self:removeFromParent() 

end


return BehaviorLogView