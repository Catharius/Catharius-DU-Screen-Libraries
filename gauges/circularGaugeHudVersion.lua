-- Put this code in library (OnStart)
-- Declare gauge in unit start
-- You can then send data to it via the draw method
CircularGauge = { FULL = 1, HALF = 2, HALF_LEFT = 3, HALF_RIGHT = 4, QUARTER = 5, QUARTER_LEFT = 6, QUARTER_TOP_LEFT = 7, QUARTER_BOTTOM_LEFT = 8, QUARTER_RIGHT = 9, QUARTER_BOTTOM_RIGHT = 10, QUARTER_TOP_RIGHT = 11 }
CircularGauge.__index = CircularGauge
function CircularGauge:new(posX, posY, circleDiameter, graduationValue, nbOfGraduation, gaugeLabel1, gaugeLabel2, gaugeType)
    local self = {
        x = posX,
        y = posY,
        circleDiameter = circleDiameter,
        graduationValue = graduationValue or 100,
        nbOfGraduation = nbOfGraduation or 10,
        gaugeLabel1 = gaugeLabel1 or "",
        gaugeLabel2 = gaugeLabel2 or "",
        gaugeType = gaugeType or CircularGauge.FULL,
        screenWidth = system.getScreenWidth(),
        screenHeight = system.getScreenHeight()
    }

    function self:draw(value, dangerZone)

        local svgRendering = ""

        if not isEmpty(gaugeType) then
            -- Declare variables
            local charWidth = (self.circleDiameter * 2.5) // 100
            local lh = (self.circleDiameter * 4) // 100
            local fontSize = (self.circleDiameter * 3) // 100
            local mediumFontSize = (self.circleDiameter * 4) // 100
            local bigFontSize = (self.circleDiameter * 5) // 100

            -- Circle variables
            local circleRadius = self.circleDiameter / 2
            local pi180 = math.pi / 180

            -- Graph type variables
            local rotation = 0
            local maxAngle = 0
            local gaugeLabelY = 0
            local drawDirection = pi180
            if gaugeType == CircularGauge.FULL then
                rotation = 135
                maxAngle = 270
                gaugeLabelY = self.y + circleRadius / 2
            elseif gaugeType == CircularGauge.HALF then
                rotation = 180
                maxAngle = 180
                gaugeLabelY = self.y - circleRadius / 2
            elseif gaugeType == CircularGauge.HALF_LEFT then
                rotation = 90
                maxAngle = 180
                gaugeLabelY = self.y - circleRadius / 2
            elseif gaugeType == CircularGauge.HALF_RIGHT then
                rotation = 90
                maxAngle = 180
                gaugeLabelY = self.y - circleRadius / 2
                drawDirection = -pi180
            elseif gaugeType == CircularGauge.QUARTER then
                rotation = 225
                maxAngle = 90
                gaugeLabelY = self.y - circleRadius / 2
            elseif gaugeType == CircularGauge.QUARTER_LEFT then
                rotation = 135
                maxAngle = 90
                gaugeLabelY = self.y - circleRadius / 2
            elseif gaugeType == CircularGauge.QUARTER_TOP_LEFT then
                rotation = 90
                maxAngle = 90
                gaugeLabelY = self.y + circleRadius / 4
                drawDirection = -pi180
            elseif gaugeType == CircularGauge.QUARTER_BOTTOM_LEFT then
                rotation = 0
                maxAngle = 90
                gaugeLabelY = self.y - circleRadius / 2
                drawDirection = -pi180
            elseif gaugeType == CircularGauge.QUARTER_RIGHT then
                rotation = 45
                maxAngle = 90
                gaugeLabelY = self.y - circleRadius / 2
                drawDirection = -pi180
            elseif gaugeType == CircularGauge.QUARTER_BOTTOM_RIGHT then
                rotation = 180
                maxAngle = 90
                gaugeLabelY = self.y - circleRadius / 2
            elseif gaugeType == CircularGauge.QUARTER_TOP_RIGHT then
                rotation = 90
                maxAngle = 90
                gaugeLabelY = self.y - circleRadius / 4
            end

            local theta = pi180 * rotation -- This allow to rotate the pie so the 0 is at x degrees for a gauge

            -- Graduation variables
            local graduationSize = self.circleDiameter // 20
            local graduationLabelOffset = self.circleDiameter // 40
            local currentGraduationLabel = 0
            local currentGraduationIncrement = 0
            local maximumGraduation = self.nbOfGraduation * self.graduationValue
            --We never go above the maximum graduation and below 0
            if value < 0 then
                value = 0
            end
            if value > maximumGraduation then
                value = maximumGraduation
            end
            local biggestGraduationWidth = #tostring(maximumGraduation) * charWidth
            local graduationIncrement = maxAngle / self.nbOfGraduation
            local valueGraduation = (value / self.graduationValue) * graduationIncrement

            -- Draw the circles
            if gaugeType == CircularGauge.FULL then
                svgRendering = svgRendering .. "<circle cx=\"" .. self.x .. "\" cy=\"" .. self.y .. "\" r=\"" .. circleRadius .. "\" fill-opacity=\"0\"stroke=\"white\" stroke-width=\"1\" />"
            end
            -- Draw indicator circle
            svgRendering = svgRendering .. "<circle cx=\"" .. self.x .. "\" cy=\"" .. self.y .. "\" r=\"" .. circleRadius/25 .. "\"  fill=\"#FFFFFF\" stroke=\"white\" stroke-width=\"1\" />"

            -- Draw the gauge description
            svgRendering = svgRendering .. "<text x=\"" .. self.x .. "\" y=\"" .. gaugeLabelY .. "\" fill=\"#FFFFFF\" font-size=\"" .. mediumFontSize .. "\" font-family=\"Play\" text-anchor=\"middle\">" .. gaugeLabel1 .. "</text>"
            gaugeLabelY = gaugeLabelY + lh + 1
            svgRendering = svgRendering .. "<text x=\"" .. self.x .. "\" y=\"" .. gaugeLabelY .. "\" fill=\"#FFFFFF\" font-size=\"" .. mediumFontSize .. "\" font-family=\"Play\" text-anchor=\"middle\">" .. gaugeLabel2 .. "</text>"
            gaugeLabelY = gaugeLabelY + lh * 2
            svgRendering = svgRendering .. "<text x=\"" .. self.x .. "\" y=\"" .. gaugeLabelY .. "\" fill=\"#FFFFFF\" font-size=\"" .. bigFontSize .. "\" font-family=\"Play\" text-anchor=\"middle\">" .. value .. "</text>"

            local drawDZ = false
            if dangerZone[1] >= 0 and dangerZone[2] >= 0 and dangerZone[2] > dangerZone[1] then
                drawDZ = true
                dangerZone[1] = (dangerZone[1] / self.graduationValue) * graduationIncrement
                dangerZone[2] = (dangerZone[2] / self.graduationValue) * graduationIncrement
            end

            for i = 0, maxAngle, 1 do
                local x1 = self.x + math.cos(theta) * (circleRadius - 1)
                local y1 = self.y + math.sin(theta) * (circleRadius - 1)
                local x2 = self.x + math.cos(theta) * (circleRadius - graduationSize)
                local y2 = self.y + math.sin(theta) * (circleRadius - graduationSize)
                local x3 = self.x + math.cos(theta) * (circleRadius - biggestGraduationWidth - graduationLabelOffset)
                local y3 = self.y + math.sin(theta) * (circleRadius - biggestGraduationWidth - graduationLabelOffset)

                -- Draw outer circle
                if gaugeType ~= CircularGauge.FULL then
                    svgRendering = svgRendering .. "<circle cx=\"" .. x1 .. "\" cy=\"" .. y1 .. "\" r=\"2\" fill=\"#FFFFFF\" stroke=\"white\" stroke-width=\"1\" />"
                end

                -- Draw the graduations
                if i >= currentGraduationIncrement and i < currentGraduationIncrement + 1 then
                    currentGraduationIncrement = currentGraduationIncrement + graduationIncrement
                    svgRendering = svgRendering .. "<line x1=\"" .. x1 .. "\" y1=\"" .. y1 .. "\" x2=\"" .. x2 .. "\" y2=\"" .. y2 .. "\" stroke=\"#FFFFFF\" stroke-width=\"2\" />"
                    svgRendering = svgRendering .. "<text x=\"" .. x3 .. "\" y=\"" .. y3 .. "\" fill=\"#FFFFFF\" font-size=\"" .. fontSize .. "\" font-family=\"Play\" text-anchor=\"middle\">" .. currentGraduationLabel .. "</text>"
                    currentGraduationLabel = currentGraduationLabel + self.graduationValue
                end

                -- Draw danger zone
                if drawDZ and i >= dangerZone[1] and i <= dangerZone[2] then
                    local x4 = self.x + math.cos(theta) * (circleRadius - 3)
                    local y4 = self.y + math.sin(theta) * (circleRadius - 3)
                    local x5 = self.x + math.cos(theta) * (circleRadius - 5)
                    local y5 = self.y + math.sin(theta) * (circleRadius - 5)
                    svgRendering = svgRendering .. "<line x1=\"" .. x4 .. "\" y1=\"" .. y4 .. "\" x2=\"" .. x5 .. "\" y2=\"" .. y5 .. "\" stroke=\"#FF0000\" stroke-width=\"3\" />"
                end

                -- Draw indicator
                if i >= valueGraduation and i < valueGraduation + 1 then
                    svgRendering = svgRendering .. "<line x1=\"" .. self.x .. "\" y1=\"" .. self.y .. "\" x2=\"" .. x1 .. "\" y2=\"" .. y1 .. "\" stroke=\"#FF0000\" stroke-width=\"2\" />"
                end
                theta = theta + drawDirection
            end
        end

        return [[<svg style="position: absolute; left:0px; top:0px" viewBox="0 0 ]] .. self.screenWidth .. [[ ]] .. self.screenHeight .. [[">]]..svgRendering..[[</svg>]]
    end

    function isEmpty(s)
        return s == nil or s == ''
    end

    function distanceFrom(x1, y1, x2, y2)
        return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    end

    return setmetatable(self, CircularGauge)
end
