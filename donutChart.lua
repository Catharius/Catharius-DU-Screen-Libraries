if not DonutChart then

    colorList = { { 65/255, 133/255, 244/255 }, { 233/255, 67/255, 53/255 }, { 250/255, 188/255, 4/255 }, { 51/255, 168/255, 83/255 }, { 255/255, 108/255, 1/255 }, { 71/255, 189/255, 198/255 }, { 123/255, 171/255, 247/255 }, { 241/255, 123/255, 114/255 }, { 252/255, 208/255, 80/255 }, { 112/255, 194/255, 135/255 }, { 255/255, 154/255, 77/255 }, { 125/255, 209/255, 215/255 }, { 179/255, 207/255, 251/255 }, { 243/255, 180/255, 174/255 }, { 254/255, 228/255, 155/255 }, { 173/255, 220/255, 186/255 }, { 255/255, 198/255, 153/255 }, { 180/255, 229/255, 232/255 } , { 233/255, 243/255, 254/255 }, { 254/255, 236/255, 235/255 } }
    DonutChart = {}
    DonutChart.__index = DonutChart
    function DonutChart:new(posX, posY, width)
        local self = {
            x = posX,
            y = posY,
            width = width,
            height = width,
            data = dataLuaArray,
            graphType = graphType
        }
        function self:draw(dataLuaArray)
            local font = loadFont("Play", tonumber(string.format('%.0f', (self.width * 4 / 100))))
            local mediumfont = loadFont("Play", tonumber(string.format('%.0f', (self.width * 6 / 100))))
            local bigfont = loadFont("Play", tonumber(string.format('%.0f', (self.width * 5 / 100))))
            local graphLayer = createLayer()
            local frontLayer = createLayer()
            local labelLayer = createLayer()
            local elementsRatio = 4
            local theta = -89.549 -- This allow to rotate pie
            local originTheta = theta
            local dtheta = math.pi / 180

            -- Get the first row of the data array and draw one pie chart per column
            local firstRow = dataLuaArray[1]
            -- Remove first value from the array
            table.remove(firstRow, 1)
            for i = 1, #firstRow do
                local graphTitle = firstRow[i]
                setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                addText(labelLayer, bigfont, graphTitle, self.x, self.y - (self.height * 30.6 / 100))
                local sumData = 0
                local dataSet = {}
                local datasetIncrement = 1
                local colorSet = {}
                -- Get data from dataLuaArray
                for j = 2, #dataLuaArray do
                    local dataLabel = dataLuaArray[j][1]
                    local data = dataLuaArray[j][i + 1]
                    -- Only positive numbers are allowed for the pie chart
                    if isempty(data) or data < 0 then
                        data = 0
                    end
                    sumData = sumData + data
                    dataSet[datasetIncrement] = { dataLabel, data }
                    datasetIncrement = datasetIncrement + 1
                    -- Attribute a color to each data label
                    colorSet[dataLabel] = colorList[j - 1]
                    -- When we reach the last column, we draw the pie chart
                    if j == #dataLuaArray then
                        local angleRatio = 360 / sumData
                        local drawInstructions = {}
                        local startAngle = 0
                        for k = 1, #dataSet do
                            local dataLabel = dataSet[k][1]
                            local angle = angleRatio * dataSet[k][2]
                            local color = colorSet[dataLabel]
                            local endAngle = startAngle + angle
                            if endAngle > 360 then
                                endAngle = 360
                            end
                            drawInstructions[k] = {
                                color = color,
                                startAngle = startAngle,
                                endAngle = endAngle,
                                dataLabel = dataLabel,
                                data = dataSet[k][2],
                                percent = dataSet[k][2] / sumData * 100
                            }
                            startAngle = endAngle + 1
                        end
                        local graphCenterX = self.x
                        local graphCenterY = self.y
                        local drawStartOffset = 0
                        -- Draw the pie chart
                        for l = 0, 360, 1 do
                            for m, n in pairs(drawInstructions) do
                                if l >= n.startAngle and l <= n.endAngle then
                                    --DRAW THE PIE CHART
                                    local x = graphCenterX + math.cos(theta) * self.width / elementsRatio
                                    local y = graphCenterY + math.sin(theta) * self.height / elementsRatio
                                    setNextStrokeColor(graphLayer, n.color[1], n.color[2], n.color[3], 1)
                                    addLine(graphLayer, graphCenterX, graphCenterY, x, y)
                                    -- If Size is too big,draw another line near the first one
                                    if self.width > 500 then
                                        setNextStrokeColor(graphLayer, n.color[1], n.color[2], n.color[3], 1)
                                        addLine(graphLayer, graphCenterX, graphCenterY, x, y - 0.2)
                                        setNextStrokeColor(graphLayer, n.color[1], n.color[2], n.color[3], 1)
                                        addLine(graphLayer, graphCenterX, graphCenterY, x, y + 0.2)
                                    end
                                    -- if we are at the middle draw label
                                    if l == tonumber(string.format('%.0f', drawStartOffset + n.endAngle / 2)) then
                                        local label = tonumber(string.format('%.2f', n.data)) .. " (" .. tonumber(string.format('%.2f', n.percent)) .. "%)"
                                        local labelWidth, labelHeight = getTextBounds(font, label or '')
                                        setNextStrokeColor(graphLayer, 1, 1, 1, 1)
                                        local xoffset = self.width / elementsRatio
                                        if l > 90 - originTheta and l <= 270 - originTheta then
                                            xoffset = -xoffset
                                            labelWidth = -labelWidth
                                        end
                                        -- if data is big enough we draw the label
                                        if n.endAngle - n.startAngle > 10 then
                                            addCircle(labelLayer, x, y, 2)
                                            addLine(labelLayer, x, y, x + xoffset, y)
                                            setNextTextAlign(labelLayer, 1, 3)
                                            addText(labelLayer, font, n.dataLabel, x + xoffset + labelWidth / elementsRatio, y - labelHeight / elementsRatio)
                                            setNextTextAlign(labelLayer, 1, 3)
                                            addText(labelLayer, font, label, x + xoffset + labelWidth / elementsRatio, y + labelHeight * elementsRatio / elementsRatio)
                                        end
                                        drawStartOffset = n.endAngle / 2 + 1
                                    end
                                end
                            end
                            theta = theta + dtheta
                        end
                        --DRAW CENTRAL DONUT
                        setNextFillColor(frontLayer, 0.001, 0, 0, 1)
                        addCircle(frontLayer, graphCenterX, graphCenterY, (self.width / elementsRatio * 0.5))
                        --DRAW TOTAL LABEL
                        setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                        addText(labelLayer, mediumfont, "TOTAL", self.x, self.y - (self.height * 3 / 100))
                        --DRAW SMALL VALUES
                        local smallValuesOffset = 0
                        for m, n in pairs(drawInstructions) do
                            if n.endAngle - n.startAngle <= 10 then
                                setNextFillColor(labelLayer, n.color[1], n.color[2], n.color[3], 1)
                                setNextTextAlign(labelLayer, AlignH_Right, AlignV_Baseline)
                                addText(labelLayer, font, n.dataLabel .. " : " .. tonumber(string.format('%.2f', n.data)) .. " (" .. tonumber(string.format('%.2f', n.percent)) .. "%)", self.x, self.y + smallValuesOffset + (self.height * 37 / 100))
                                smallValuesOffset = smallValuesOffset + getFontSize(font)
                            end
                        end
                        if smallValuesOffset>0 then
                            setNextTextAlign(labelLayer, AlignH_Center, AlignV_Baseline)
                            addText(labelLayer, font, "Hidden values", self.x, self.y + (self.height * 33 / 100))
                        end
                        local fontToUse = mediumfont
                        -- if sumData has more than 6 digits, use a smaller font
                        if sumData > 999999 then
                            fontToUse = font
                        end
                        setNextTextAlign(labelLayer, AlignH_Center, AlignV_Middle)
                        addText(labelLayer, fontToUse, tonumber(string.format('%.0f', sumData)), self.x, self.y)
                        -- Clear data for next pie chart
                        sumData = 0
                        dataSet = {}
                    end
                end
                -- For now only one pie chart per column is supported (Too cpu intensive to draw more than one pie chart per column)
                break
            end
        end

        function isempty(s)
            return s == nil or s == ''
        end

        return setmetatable(self, DonutChart)
    end
end

local rx, ry = getResolution()
-- Declared only once
if not alreadyDeclared then
    alreadyDeclared = true
    -- We declare here our chart object (position X and Y are the center of the chart, width is it's size
    -- Disclaimer : if width is too big, the chart will have some rendering problems
    testPie = DonutChart:new(rx / 2, ry / 2, 400)
end

-- In this example, i draw a static chart only on the first frame, if you want a dynamic one, remove the if statement (Warning : Drawing this at every frame is not wise)
if not firstBoot then
    local testData = { { "", "My ore stock" }, { "Iron", 100 }, { "Silicon", 30 }, { "Gold", 5 }, { "Lithium", 0.2 }, { "Thoramine", 0.2 } }
    testPie:draw(testData)
    firstBoot = true
end
