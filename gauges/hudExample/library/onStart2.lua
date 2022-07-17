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
