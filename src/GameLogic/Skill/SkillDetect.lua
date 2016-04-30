local SkillDetect = {}

--探测范围 插件

function SkillDetect:getSkillDetectPosList(initPos,skillRangeInfo)
    
    local posList = {}
    --根据 技能ID 去找到 skillRangeType,skillRange ，再找到 坐标组

    if skillRangeInfo and initPos then 

        local posTable = string.split(skillRangeInfo.PosTable,"|") 
        
        for k,v in ipairs(posTable) do
        	if v and v ~= "" then 
               local posT = string.split(v,",") 
               local dPosX = tonumber(posT[1])
               local dPosY = tonumber(posT[2])
              
               local pos = cc.p(initPos.x + dPosX,initPos.y + dPosY)
               local isRepeat = false 
               --这里要不要检测 是否重复 
               for kk,vv in ipairs(posList) do
               	   if vv and vv.x == pos.x and vv.y == pos.y then 
               	   	  isRepeat = true 
               	   	  break 
                   end
               end

               if isRepeat  == false then 
                  table.insert(posList,pos)
               end
               
        	end
        end
    end
    --这里需要进行一个排序  离initPos 近的点 排在前面
    -- table.sort( posList, function ( a,b )
    --     local widthA = math.abs(initPos.x-a.x)
    --     local heightA = math.abs(initPos.y-a.y)
    --     local distanceA = math.sqrt( math.pow(widthA,2) + math.pow(heightA,2) )
    --     local widthB = math.abs(initPos.x-b.x)
    --     local heightB = math.abs(initPos.y-b.y)
    --     local distanceB = math.sqrt( math.pow(widthB,2) + math.pow(heightB,2) )

    --     if distanceA > distanceB then 
    --        return false
    --     else
    --        return true 
    --     end
    -- end )

    return posList

end


function SkillDetect:getSkillRangeDiagram(skillRangeInfo)
    local node = cc.Node:create()

    if skillRangeInfo then 
	
	    local posTable = string.split(skillRangeInfo.PosTable,"|") 
	    
	    for k,v in ipairs(posTable) do
	    	if v and v ~= "" then 
	           local posT = string.split(v,",") 
	           local dPosX = tonumber(posT[1])
	           local dPosY = tonumber(posT[2])
	          
	           local sprite = cc.Sprite:create("publish/resource/Common/skillRange.png")
	           local width = sprite:getContentSize().width
	           sprite:setPosition(cc.p(dPosX*(width+2),dPosY*(width+2)))
	           sprite:setOpacity(0.8)

	           local action1 = cc.FadeTo:create(1,255*0.4)
	           local action2 = cc.FadeTo:create(1,255*0.8)
	           sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(action1,action2))) 

	           node:addChild(sprite,5)
	           
	    	end
	    end
    else
        print("skillID 为空值")
    end
    --这里的 技能显示 是上下反过来的，所以需要 再反过来一次。
    --只是显示技能范围 所以 无须在意
    node:setScaleY(-1)


	return node 
	
end


return SkillDetect