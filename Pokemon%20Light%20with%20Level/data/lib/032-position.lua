function isInRange(position, fromPosition, toPosition)
	return (position.x >= fromPosition.x and position.y >= fromPosition.y and position.z >= fromPosition.z and position.x <= toPosition.x and position.y <= toPosition.y and position.z <= toPosition.z)
end

function getDistanceBetween(fromPosition, toPosition)
	local x, y = math.abs(fromPosition.x - toPosition.x), math.abs(fromPosition.y - toPosition.y)
	local diff = math.max(x, y)
	if(fromPosition.z ~= toPosition.z) then
		diff = diff + 9 + 6
	end
	
	return diff
end

function getDirectionTo(pos1, pos2)
	local dir = NORTH
	if(pos1.x > pos2.x) then
		dir = WEST
		if(pos1.y > pos2.y) then
			dir = NORTHWEST
		elseif(pos1.y < pos2.y) then
			dir = SOUTHWEST
		end
	elseif(pos1.x < pos2.x) then
		dir = EAST
		if(pos1.y > pos2.y) then
			dir = NORTHEAST
		elseif(pos1.y < pos2.y) then
			dir = SOUTHEAST
		end
	else
		if(pos1.y > pos2.y) then
			dir = NORTH
		elseif(pos1.y < pos2.y) then
			dir = SOUTH
		end
	end
	
	return dir
end

function getCreatureLookPosition(cid)
	return getPosByDir(getThingPos(cid), getCreatureLookDirection(cid))
end

function getPositionByDirection(position, direction, size)
	local n = size or 1
	if(direction == NORTH) then
		position.y = position.y - n
	elseif(direction == SOUTH) then
		position.y = position.y + n
	elseif(direction == WEST) then
		position.x = position.x - n
	elseif(direction == EAST) then
		position.x = position.x + n
	elseif(direction == NORTHWEST) then
		position.y = position.y - n
		position.x = position.x - n
	elseif(direction == NORTHEAST) then
		position.y = position.y - n
		position.x = position.x + n
	elseif(direction == SOUTHWEST) then
		position.y = position.y + n
		position.x = position.x - n
	elseif(direction == SOUTHEAST) then
		position.y = position.y + n
		position.x = position.x + n
	end
	
	return position
end

function doComparePositions(position, positionEx)
	return position.x == positionEx.x and position.y == positionEx.y and position.z == positionEx.z
end

function getArea(position, x, y)
	local t = {}
	for i = (position.x - x), (position.x + x) do
		for j = (position.y - y), (position.y + y) do
			table.insert(t, {x = i, y = j, z = position.z})
		end
	end
	
	return t
end

function getPosfromArea(cid,area)
	icenter = math.floor(table.getn(area)/2)+1
	jcenter = math.floor(table.getn(area[1])/2)+1
	center = area[icenter]
	ivar = table.getn(area)
	jvar = table.getn(area[1])
	i = table.getn(area)^2
	j = table.getn(area[1])^2
	
	local mydir = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)
	setPlayerStorageValue(cid, 21101, -1) --alterado v1.6
	
	if center[jcenter] == 3 then
		if mydir == 0 then
			signal = {-1,1,1,2}
		elseif mydir == 1 then
			signal = {1,-1,2,1}
		elseif mydir == 2 then
			signal = {1,-1,1,2}
		elseif mydir == 3 then
			signal = {-1,1,2,1}
		end
	else
		signal = {-1,1,1,2}
	end
	
	POSITIONS = {} 
	P = 0 
	
	repeat
		pvar = {0,0}
		I = area[ivar]
		J = I[jvar]
		i = i-1
		j = j-1
		if J == 1 then
			if jvar < jcenter then 
				pvar[signal[3]] = signal[1]*math.abs((jcenter-jvar)) 
			elseif jvar > jcenter then 
				pvar[signal[3]] = signal[2]*math.abs((jcenter-jvar)) 
			end
			
			if ivar < icenter then 
				pvar[signal[4]] = signal[1]*math.abs((icenter-ivar)) 
			elseif ivar > icenter then
				pvar[signal[4]] = signal[2]*math.abs((icenter-ivar))
			end
		end 
		if jvar > 1 then
			jvar = (jvar-1)
		elseif ivar > 1 then
			jvar = table.getn(area[1])
			ivar = (ivar-1)
		end 
		local pos = getThingPos(cid)
		local areapos = {x=pos.x+(pvar[1]),y=pos.y+(pvar[2]),z=pos.z} 
		
		if pos.x ~= areapos.x or pos.y ~= areapos.y then
			P = P+1
			POSITIONS[P] = areapos
		end 
		
	until i <= 0 and j <= 0
	
	return POSITIONS
end