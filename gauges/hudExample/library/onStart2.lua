function getFuelLevel(fueltank)
    local fuelpercentage = -1
    local obj, pos, err = json.decode(fueltank.getData(), 1, nil)
    if err then
    else
        -- Computing fuel percentage
        if obj.percentage ~= nil then
            fuelpercentage = obj.percentage
        end
    end
    return fuelpercentage
end

function getSpeed(coordinates)
    local locVelVec = vec3(coordinates)
    local locVelVecLen = locVelVec:len()
    local speedValue = 0
    if locVelVecLen > 0.3 then
        local locVelVecN = locVelVec:normalize()
        local rY, rX = 0,0
        rY = -math.asin(locVelVecN.x)
        rX = -math.asin(locVelVecN.z)

        if locVelVec.y < 0 then
            rY = (rY < 0 and -1 or 1) * math.pi - rY
        end

        local hPos = locVelVecN*1700
        speedValue = locVelVecLen*3.6
    end
    return speedValue
end
