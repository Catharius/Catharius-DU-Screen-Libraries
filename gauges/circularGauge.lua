if not CircularGauge then
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
            gaugeType = gaugeType or CircularGauge.FULL
        }

        function self:draw(value, dangerZone)

            if not isEmpty(gaugeType) then
                -- Declare variables
                local backgroundLayer = createLayer()
                local graduationLayer = createLayer()
                local fontSize = (self.circleDiameter * 3) // 100
                local mediumFontSize = (self.circleDiameter * 4) // 100
                local bigFontSize = (self.circleDiameter * 5) // 100

                local font = loadFont("Play", fontSize)

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
                    gaugeLabelY = self.y + circleRadius / 2
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
                local biggestGraduationWidth, biggestGraduationHeight = getTextBounds(font, tostring(maximumGraduation))
                local graduationIncrement = maxAngle / self.nbOfGraduation
                local valueGraduation = (value / self.graduationValue) * graduationIncrement

                -- Draw the circles
                if gaugeType == CircularGauge.FULL then
                    addCircle(backgroundLayer, self.x, self.y, circleRadius)
                    setNextFillColor(backgroundLayer, 0.001, 0, 0, 1)
                    addCircle(backgroundLayer, self.x, self.y, circleRadius - 3)
                end
                -- Draw indicator circle
                setNextFillColor(backgroundLayer, 1, 1, 1, 1)
                addCircle(backgroundLayer, self.x, self.y, self.circleDiameter / 25)

                setFontSize(font, mediumFontSize)
                -- Draw the gauge description
                setNextTextAlign(backgroundLayer, AlignH_Center, AlignV_Baseline)
                addText(backgroundLayer, font, gaugeLabel1, self.x, gaugeLabelY)
                local lw, lh = getTextBounds(font, gaugeLabel1)
                gaugeLabelY = gaugeLabelY + lh + 1
                setNextTextAlign(backgroundLayer, AlignH_Center, AlignV_Middle)
                addText(backgroundLayer, font, gaugeLabel2, self.x, gaugeLabelY)
                lw, lh = getTextBounds(font, gaugeLabel2)
                setNextTextAlign(backgroundLayer, AlignH_Center, AlignV_Middle)
                gaugeLabelY = gaugeLabelY + lh * 2
                setFontSize(font, bigFontSize)
                addText(backgroundLayer, font, value, self.x, gaugeLabelY)
                setFontSize(font, fontSize)

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
                        addCircle(backgroundLayer, x1, y1, 2)
                    end
                    
                    -- Draw the graduations
                    if i >= currentGraduationIncrement and i < currentGraduationIncrement + 1 then
                        currentGraduationIncrement = currentGraduationIncrement + graduationIncrement
                        setNextStrokeWidth(graduationLayer, 2)
                        addLine(graduationLayer, x1, y1, x2, y2)
                        setNextTextAlign(graduationLayer, AlignH_Center, AlignV_Middle)
                        addText(graduationLayer, font, currentGraduationLabel, x3, y3)
                        currentGraduationLabel = currentGraduationLabel + self.graduationValue
                    end
                    
                    -- Draw danger zone
                    if drawDZ and i >= dangerZone[1] and i <= dangerZone[2] then
                        setNextStrokeColor(graduationLayer, 1, 0, 0, 1)
                        setNextStrokeWidth(graduationLayer, 3)
                        local x4 = self.x + math.cos(theta) * (circleRadius - 3)
                        local y4 = self.y + math.sin(theta) * (circleRadius - 3)
                        local x5 = self.x + math.cos(theta) * (circleRadius - 5)
                        local y5 = self.y + math.sin(theta) * (circleRadius - 5)
                        addLine(graduationLayer, x4, y4, x5, y5)
                    end
                    
                    -- Draw indicator
                    if i >= valueGraduation and i < valueGraduation + 1 then
                        setNextStrokeColor(graduationLayer, 1, 0, 0, 1)
                        addLine(graduationLayer, self.x, self.y, x1, y1)
                    end
                    theta = theta + drawDirection
                end
            end
        end

        function isEmpty(s)
            return s == nil or s == ''
        end

        function distanceFrom(x1, y1, x2, y2)
            return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
        end

        return setmetatable(self, CircularGauge)
    end
end
-- END OF LIBRARY FUNCTIONS --



local rx, ry = getResolution()
-- Declared only once
if not alreadyDeclared then
    alreadyDeclared = true

    -- CircularGauge:new(posX, posY, circleDiameter, graduationValue, nbOfGraduation, gaugeLabel1, gaugeLabel2, gaugeType)
    -- You can choose the gauges types (FULL, HALF, HALF_LEFT, HALF_RIGHT,QUARTER, QUARTER_LEFT, QUARTER_TOP_LEFT, QUARTER_BOTTOM_LEFT, QUARTER_RIGHT, QUARTER_BOTTOM_RIGHT, QUARTER_TOP_RIGHT)
    -- Here i want a gauge with graduations 100 by 100 and 10 graduations so from 0 to 1000
    centralTestGauge = CircularGauge:new(rx / 2, ry / 2, 400, 200, 10, "Current Speed", "km/h", CircularGauge.FULL)

    -- Then i want  two gauges on the left corners of my screen for fuel monitoring
    topLeftTestGauge = CircularGauge:new(40, 40, 300, 10, 10, "Nitron", "%", CircularGauge.QUARTER_TOP_LEFT)
    bottomLeftTestGauge = CircularGauge:new(40, ry - 40, 300, 10, 10, "Kergon", "%", CircularGauge.QUARTER_BOTTOM_LEFT)

    -- And at last a half circle gauge on the right side to view my throttle position
    rightTestGauge = CircularGauge:new(rx - 100, ry - 200, 330, 10, 10, "Throttle", "%", CircularGauge.HALF_LEFT)
end

-- Here i want to draw the centralGauge, i pass 50 km/h as value (This is an example, the real data should be passed from the piloting seat to the screen)
-- Since i want to see if i will burn if i'm speeding too much i want to setup a red zone on the circle to indicate that i'm in danger of dying
-- Let's say from 1850 to max (here it is 2000)
centralTestGauge:draw(50, { 1850, 2000 })

-- Here i'm in the red when i have 15% fuel left
topLeftTestGauge:draw(66, { 0, 15 })
bottomLeftTestGauge:draw(34, { 0, 15 })

-- Here i have a throttle at 40%, and i don't want a red indicator so we put -1 as min and max
rightTestGauge:draw(40, { -1, -1 })

-- Note that if you don't need real time gauge data you can remove this line, a simple mouse click will refresh the gauge
requestAnimationFrame(1)
