if not DonutChart then
    DonutChart = {}
    DonutChart.__index = DonutChart
    function DonutChart:new(posX, posY, circleDiameter, dataUnit, showSmallValues)
        local self = {
            x = posX,
            y = posY,
            circleDiameter = circleDiameter,
            data = dataLuaArray,
            graphType = graphType,
            dataUnit = dataUnit or '',
            showSmallValues = showSmallValues or false,
            colorList = { { 65 / 255, 133 / 255, 244 / 255 }, { 233 / 255, 67 / 255, 53 / 255 }, { 250 / 255, 188 / 255, 4 / 255 }, { 51 / 255, 168 / 255, 83 / 255 }, { 255 / 255, 108 / 255, 1 / 255 }, { 71 / 255, 189 / 255, 198 / 255 }, { 123 / 255, 171 / 255, 247 / 255 }, { 241 / 255, 123 / 255, 114 / 255 }, { 252 / 255, 208 / 255, 80 / 255 }, { 112 / 255, 194 / 255, 135 / 255 }, { 255 / 255, 154 / 255, 77 / 255 }, { 125 / 255, 209 / 255, 215 / 255 }, { 179 / 255, 207 / 255, 251 / 255 }, { 243 / 255, 180 / 255, 174 / 255 }, { 254 / 255, 228 / 255, 155 / 255 }, { 173 / 255, 220 / 255, 186 / 255 }, { 255 / 255, 198 / 255, 153 / 255 }, { 180 / 255, 229 / 255, 232 / 255 }, { 233 / 255, 243 / 255, 254 / 255 }, { 254 / 255, 236 / 255, 235 / 255 } },
            currentCentralMenu = 1
        }

        function self:draw(dataLuaArray)
            -- Declare variables
            local backgroundLayer = createLayer()
            local pieLayer = createLayer()
            local centralLayer = createLayer()
            local labelLayer = createLayer()

            local font = loadFont("Play", tonumber(string.format('%.0f', (self.circleDiameter * 4 / 100))))
            local mediumFont = loadFont("Play", tonumber(string.format('%.0f', (self.circleDiameter * 6 / 100))))
            local bigFont = loadFont("Play", tonumber(string.format('%.0f', (self.circleDiameter * 5 / 100))))

            local circleRadius = self.circleDiameter / 2
            local mediumLabelY=self.y-circleRadius/3
            local labelWSpacing = self.circleDiameter/12
            local labelHSpacing = 2
            local pi180 = math.pi / 180

            local theta = pi180 * 270 -- This allow to rotate the pie
            local dataSum = 0
            local dataMin = {-1,-1,""}
            local dataMax = {-1,-1,""}

            -- Get the first row of the data array (it is the column header of the data)
            local firstRow = dataLuaArray[1]
            -- Remove first value from the array as it is never used
            table.remove(firstRow, 1)
            -- For each columns
            for i = 1, #firstRow do
                -- Draw title at the top of the graph
                local graphTitle = firstRow[i]
                setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                local _, bigFontHeight = getTextBounds(bigFont, graphTitle)
                addText(labelLayer, bigFont, graphTitle, self.x, self.y - circleRadius - bigFontHeight)

                -- Compute the sum of the values, we need it first to calculate angles to draw
                for j = 2, #dataLuaArray do
                    dataSum = dataSum + dataLuaArray[j][i + 1]
                end
                local angleRatio = 360 / dataSum
                local startAngle = 0

                local leftLabelList = {}
                local rightLabelList = {}
                local biggestLabelWidth = 0
                local lastColor = {}
                -- For each rows
                for k = 2, #dataLuaArray do
                    local dataLabel = dataLuaArray[k][1]
                    local data = dataLuaArray[k][i + 1]
                    local color = self.colorList[k - 1]
                    lastColor = color
                    local dataLabelWidth, dataLabelHeight = getTextBounds(font, dataLabel or '')
                    -- Getting min and max
                    if dataLabelWidth > biggestLabelWidth then
                        biggestLabelWidth = dataLabelWidth
                    end
                    if dataMin[1] > data or dataMin[1]<0 then
                        dataMin[1] = data
                        dataMin[2] = dataLabelHeight
                        dataMin[3] = dataLabel
                    end
                    if dataMax[1] < data or dataMax[1]<0 then
                        dataMax[1] = data
                        dataMax[2] = dataLabelHeight
                        dataMax[3] = dataLabel
                    end
                    -- Only positive numbers are allowed for the pie chart
                    if isEmpty(data) or data < 0 then
                        data = 0
                    end
                    -- Compute angles
                    local endAngle = startAngle + angleRatio * data
                    endAngle = tonumber(string.format('%.0f', endAngle))
                    if (endAngle > 360) then
                        endAngle = 360
                    end
                    local angleToDraw = endAngle - startAngle
                    -- Draw the current data
                    for i = 1, angleToDraw do
                        local x2 = self.x + math.cos(theta) * circleRadius
                        local y2 = self.y + math.sin(theta) * circleRadius

                        --Draw the pie
                        if self.circleDiameter < 300 then
                            setNextStrokeWidth(pieLayer, 2)
                        else
                            setNextStrokeWidth(pieLayer, 4)
                        end
                        setNextStrokeColor(pieLayer, color[1], color[2], color[3], 1)
                        addLine(pieLayer, self.x, self.y, x2, y2)

                        -- If we are at the middle, compute label
                        if i == tonumber(string.format('%.0f', angleToDraw / 2)) then
                            -- We need to store the label in a table to be able to draw it later properly
                            local labelValue = tonumber(string.format('%.2f', data)) .. " "..dataUnit.."(" .. tonumber(string.format('%.2f', (data / dataSum * 100))) .. "%)"
                            local labelWidth, labelHeight = getTextBounds(font, labelValue or '')
                            if labelWidth > biggestLabelWidth then
                                biggestLabelWidth = labelWidth
                            end
                            if x2 >= self.x then
                                rightLabelList[#rightLabelList + 1] = { dataLabel = dataLabel, labelValue = labelValue, x = x2, y = y2, width = labelWidth, height = labelHeight, dataAngle = dataAngle, color = color }
                            else
                                leftLabelList[#leftLabelList + 1] = { dataLabel = dataLabel, labelValue = labelValue, x = x2, y = y2, width = labelWidth, height = labelHeight, dataAngle = dataAngle, color = color }
                            end
                        end
                        theta = theta + pi180
                    end
                    startAngle = endAngle
                end

                local lowerOccupiedY = -1
                local leftDataX = self.x-circleRadius-biggestLabelWidth- labelWSpacing
                local rightDataX = self.x+circleRadius+biggestLabelWidth+ labelWSpacing
                -- Draw labels on the left side of the graph from the top to the bottom
                table.sort(leftLabelList, function(a, b) return a.y < b.y end)
                for i = 1, #leftLabelList do
                    local labelValue = leftLabelList[i].labelValue
                    local dataLabel = leftLabelList[i].dataLabel
                    local x = leftLabelList[i].x
                    local y = leftLabelList[i].y
                    local height=leftLabelList[i].height
                    local labelY = y
                    -- Is the spot taken ? if so we need to move down a bit
                    if lowerOccupiedY>=0 and labelY-height < lowerOccupiedY then
                        labelY = lowerOccupiedY + height + labelHSpacing
                    end
                    -- Text
                    setNextTextAlign(labelLayer, AlignH_Left, AlignV_Top)
                    addText(labelLayer, font, dataLabel,leftDataX, labelY-height)
                    setNextTextAlign(labelLayer, AlignH_Left, AlignV_Baseline)
                    addText(labelLayer, font, labelValue, leftDataX, labelY+height)
                    -- Lines
                    local lineX2 = leftDataX+biggestLabelWidth+ labelWSpacing /2
                    local lineY2 = labelY
                    addLine(labelLayer, leftDataX, lineY2, lineX2, lineY2)
                    addLine(labelLayer, lineX2, lineY2, x, y)
                    addCircle(labelLayer, x, y, 2)
                    lowerOccupiedY = labelY+height
                end
                -- Draw labels on the right side of the graph
                lowerOccupiedY = -1
                table.sort(rightLabelList, function(a, b) return a.y < b.y end)
                for i = 1, #rightLabelList do
                    local labelValue = rightLabelList[i].labelValue
                    local dataLabel = rightLabelList[i].dataLabel
                    local x = rightLabelList[i].x
                    local y = rightLabelList[i].y
                    local height=rightLabelList[i].height
                    local width=rightLabelList[i].width
                    local widthOffset=width/4
                    local labelY = y
                    -- Is the spot taken ? if so we need to move down a bit
                    if lowerOccupiedY>=0 and labelY-height < lowerOccupiedY then
                        labelY = lowerOccupiedY + height + labelHSpacing
                    end
                    -- Text
                    setNextTextAlign(labelLayer, AlignH_Right, AlignV_Top)
                    addText(labelLayer, font, dataLabel,rightDataX+widthOffset, labelY-height)
                    setNextTextAlign(labelLayer, AlignH_Right, AlignV_Baseline)
                    addText(labelLayer, font, labelValue, rightDataX+widthOffset, labelY+height)
                    -- Lines
                    local lineX2 = rightDataX+widthOffset
                    local lineY2 = labelY
                    addLine(labelLayer, rightDataX-width, lineY2, lineX2, lineY2)
                    addLine(labelLayer, rightDataX-width, lineY2, x, y)
                    addCircle(labelLayer, x, y, 2)
                    lowerOccupiedY = labelY+height
                end
                -- Draw pie background
                setNextFillColor(backgroundLayer,lastColor[1], lastColor[2], lastColor[3], 1)
                addCircle(backgroundLayer, self.x, self.y, circleRadius)

                local mx, my = getCursor()
                if distanceFrom(self.x, self.y, mx, my)<=circleRadius/2 then
                    --Draw central zone
                    setNextFillColor(centralLayer,1, 1, 1, 1)
                    addCircle(centralLayer, self.x, self.y, circleRadius/1.9)
                end

                local released = getCursorReleased()
                if released then
                    local mx, my = getCursor()
                    if distanceFrom(self.x, self.y, mx, my)<=circleRadius/2 then
                        self.currentCentralMenu = self.currentCentralMenu+1
                        if self.currentCentralMenu>4 then
                            self.currentCentralMenu = 1
                        end
                    end
                end
                local mediumLabelY=self.y-circleRadius/3
                if self.currentCentralMenu == 1 then
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, "TOTAL", self.x, mediumLabelY)
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, tonumber(string.format('%.2f', dataSum)), self.x, self.y)
                elseif self.currentCentralMenu == 2 then
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, "AVG", self.x, mediumLabelY)
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, tonumber(string.format('%.2f', dataSum/(#dataLuaArray-1))), self.x, self.y)
                elseif self.currentCentralMenu == 3 then
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, "MIN", self.x, mediumLabelY)
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, dataMin[3], self.x, self.y-dataMin[2])
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, tonumber(string.format('%.2f', dataMin[1])), self.x, self.y+dataMin[2])
                elseif self.currentCentralMenu == 4 then
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, "MAX", self.x, mediumLabelY)
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, dataMax[3], self.x, self.y-dataMax[2])
                    setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                    addText(labelLayer, mediumFont, tonumber(string.format('%.2f', dataMax[1])), self.x, self.y+dataMax[2])
                end

                --Draw central zone
                setNextFillColor(centralLayer, 0.001, 0, 0, 1)
                addCircle(centralLayer, self.x, self.y, circleRadius/2)


                -- For now only one pie chart per column is supported (Too cpu intensive to draw more than one pie chart per column)
                break
            end
        end

        function isEmpty(s)
            return s == nil or s == ''
        end

        function distanceFrom(x1,y1,x2,y2)
            return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
        end

        return setmetatable(self, DonutChart)
    end
end
-- END OF LIBRARY FUNCTIONS --



local rx, ry = getResolution()
-- Declared only once
if not alreadyDeclared then
    alreadyDeclared = true
    -- We declare here our chart object (position X and Y are the center of the chart, width is it's size
    -- Disclaimer : you choose the diameter of the chart but in order to see the labels on the side, do not use the entire screen width as diameter)
    testPie = DonutChart:new(rx / 2, ry / 2, 400, "kg")
end

-- In this example, i draw a static chart only on the first frame, if you want a dynamic one, remove the if statement (Warning : Drawing this at every frame is not wise)
local testData = { { "", "My ore stock" }, { "Data 1", 1 }, { "Data 2", 10 },{ "Data 3", 10 },{ "Data 4", 10 },{ "Data 5", 10 },{ "Data 6", 10 },{ "Data 7", 10 },{ "Data 8", 10 },{ "Data 9", 10 },}
testPie:draw(testData)

-- Note that if you don't need real time chart data you can remove this line, a simple mouse click will refresh the chart
requestAnimationFrame(1)

