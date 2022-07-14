if not CircularGauge then
    CircularGauge = {}
    CircularGauge.__index = CircularGauge
    function CircularGauge:new(posX, posY, circleDiameter, graduationValue, nbOfGraduation, gaugeLabel1, gaugeLabel2)
        local self = {
            x = posX,
            y = posY,
            circleDiameter = circleDiameter,
            graduationValue = graduationValue or 100,
            nbOfGraduation = nbOfGraduation or 10,
            gaugeLabel1 = gaugeLabel1 or "",
            gaugeLabel2 = gaugeLabel2 or ""
        }

        function self:draw(value)
            -- Declare variables
            local backgroundLayer = createLayer()
            local graduationLayer = createLayer()
            local font = loadFont("Play", (self.circleDiameter * 3) // 100)
            local mediumFont = loadFont("Play", (self.circleDiameter * 4) // 100)
            local bigFont = loadFont("Play", (self.circleDiameter * 5) // 100)

            -- Circle variables
            local circleRadius = self.circleDiameter / 2
            local pi180 = math.pi / 180
            local theta = pi180 * 135 -- This allow to rotate the pie so the 0 is at x degrees for a gauge

            -- Graduation variables
            local graduationSize = self.circleDiameter // 20
            local graduationLabelOffset = self.circleDiameter // 40
            local currentGraduationLabel = 0
            local currentGraduationIncrement = 0
            local maximumGraduation = self.nbOfGraduation*self.graduationValue
            --We never go above the maximum graduation and below 0
            if value<0 then
                value = 0
            end
            if value > maximumGraduation then
                value = maximumGraduation
            end
            local biggestGraduationWidth, biggestGraduationHeight = getTextBounds(font, tostring(maximumGraduation))
            local graduationIncrement = 270 / self.nbOfGraduation
            local valueGraduation = (value/self.graduationValue)*graduationIncrement

            -- Draw the circles
            addCircle(backgroundLayer, self.x, self.y, circleRadius)
            setNextFillColor(backgroundLayer, 0.001, 0, 0, 1)
            addCircle(backgroundLayer, self.x, self.y, circleRadius - 3)
            setNextFillColor(backgroundLayer, 1, 1, 1, 1)
            addCircle(backgroundLayer, self.x, self.y, self.circleDiameter / 20)

            -- Draw the gauge description
            local gaugeLabelY = self.y+circleRadius/2
            setNextTextAlign(backgroundLayer, AlignH_Center, AlignV_Baseline)
            addText(backgroundLayer, mediumFont, gaugeLabel1, self.x, gaugeLabelY)
            local lw, lh = getTextBounds(font, gaugeLabel1)
            gaugeLabelY = gaugeLabelY + lh + 1
            setNextTextAlign(backgroundLayer, AlignH_Center, AlignV_Middle)
            addText(backgroundLayer, mediumFont, gaugeLabel2, self.x, gaugeLabelY)
            lw, lh = getTextBounds(font, gaugeLabel2)
            setNextTextAlign(backgroundLayer, AlignH_Center, AlignV_Middle)
            gaugeLabelY = gaugeLabelY + lh*2
            addText(backgroundLayer, bigFont, value, self.x,  gaugeLabelY)

            for i = 0, 270, 1 do
                local x1 = self.x + math.cos(theta) * (circleRadius-1)
                local y1 = self.y + math.sin(theta) * (circleRadius-1)
                local x2 = self.x + math.cos(theta) * (circleRadius-graduationSize)
                local y2 = self.y + math.sin(theta) * (circleRadius-graduationSize)
                local x3 = self.x + math.cos(theta) * (circleRadius-biggestGraduationWidth-graduationLabelOffset)
                local y3 = self.y + math.sin(theta) * (circleRadius-biggestGraduationWidth-graduationLabelOffset)
                -- Draw the graduations
                if i >= currentGraduationIncrement and i<currentGraduationIncrement+1 then
                    currentGraduationIncrement = currentGraduationIncrement + graduationIncrement
                    setNextStrokeWidth(graduationLayer, 2)
                    addLine(graduationLayer, x1, y1, x2, y2)
                    setNextTextAlign(graduationLayer, AlignH_Center, AlignV_Middle)
                    addText(graduationLayer, font, currentGraduationLabel, x3, y3)
                    currentGraduationLabel = currentGraduationLabel + self.graduationValue
                end
                -- Draw indicator
                if i >= valueGraduation and i < valueGraduation+1 then
                    setNextStrokeColor(graduationLayer, 1, 0, 0, 1)
                    addLine(graduationLayer, self.x, self.y, x1, y1)
                end
                theta = theta + pi180
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
    -- Gauge:new(posX, posY, circleDiameter, graduationValue, NbOfGraduation, gaugeLabel1, gaugeLabel2)

    -- Here i want a gauge with graduations 100 by 100 and 10 graduations so from 0 to 1000
    testGauge = CircularGauge:new(rx / 2, ry / 2, 400, 100, 10, "Current Speed", "km/h")
end

-- We draw the gauge with a value of 50
testGauge:draw(50)

-- Note that if you don't need real time gauge data you can remove this line, a simple mouse click will refresh the gauge
requestAnimationFrame(1)
