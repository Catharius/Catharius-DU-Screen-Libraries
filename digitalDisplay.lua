--# Add this code in the screen lua content editor
--# Allow you to generate digital display counters
--# See example code at the bottom of this file
--# See https://www.electronics-tutorials.ws/blog/7-segment-display-tutorial.html to learn the principles of a 7 segment display

if not DigitalDisplay then

    DigitalDisplay = {}
    DigitalDisplay.__index = DigitalDisplay

    function DigitalDisplay:new(x, y, sizeRatio, nbDigit, rColor, gColor, bColor, lightOffBrightness, lightOnBrightness)

        local self = {
            x = x or 0,
            y = y or 0,
            size = sizeRatio or 1,
            maxDigit = nbDigit or 1,
            r = rColor or 1,
            g = gColor or 0,
            b = bColor or 0,
            lightOffBrightness = lightOffBrightness or 0.1,
            lightOnBrightness = lightOnBrightness or 1,
            horizontalLineWidth = 10 * sizeRatio,
            horizontalLineHeight = 4 * sizeRatio,
            triangleWidth = 4 * sizeRatio,
            verticalLineWidth = 4 * sizeRatio,
            verticalLineHeight = 10 * sizeRatio,
            lineSpacing = 1 * sizeRatio -- Spacing between number segments
        }

        function self:draw(layer, numberToDraw)
            local  maxDigit, horizontalLineWidth, triangleWidth, lineSpacing = self.maxDigit, self.horizontalLineWidth, self.triangleWidth, self.lineSpacing
            local setAllToNine = false
            local nbIntegers = 0
            local nbDecimal = 0
            local nbDecimalToKeep = 0
            -- if we have decimals, we count the number of integer and digits
            if string.find(tostring(numberToDraw), "%.") then
                split_nb = split(tostring(numberToDraw), "%.")
                nbIntegers = #split_nb[1]:gsub("%%", "")
                if split_nb[2] then
                    nbDecimal = #split_nb[2]:gsub("%%", "")
                end
            else
                nbIntegers = #tostring(numberToDraw)
            end
            if nbIntegers > maxDigit then
                -- if we have not enough counters for integer, set all of them to 9
                setAllToNine = true
            else
                if (nbIntegers + nbDecimal) > maxDigit then
                    -- we need to keep a maximum amount of digits
                    nbDecimalToKeep = maxDigit - nbIntegers
                else
                    nbDecimalToKeep = nbDecimal
                end
            end
            if nbDecimalToKeep > 0 then
                --Rounding the number
                numberToDraw = tonumber(string.format('%.' .. nbDecimalToKeep .. 'f', numberToDraw))
            else
                --Round
                numberToDraw = tonumber(string.format('%.0f', numberToDraw))
            end
            local numberStr = ''
            if setAllToNine then
                for _ = 1, maxDigit, 1 do
                    numberStr = numberStr .. '9'
                end
            else
                local numberPadding = maxDigit - (nbIntegers + nbDecimalToKeep)
                -- Case when we have more counters than numbers to display
                if numberPadding > 0 then
                    for _ = 1, numberPadding, 1 do
                        numberStr = numberStr .. 'X'
                    end
                    numberStr = numberStr .. numberToDraw
                else
                    -- Everything is ok
                    numberStr = numberToDraw
                end
            end
            --Put the string into a table
            local numberTable = {}
            numberStr = tostring(numberStr)
            local indexToRemove = 0
            for i = 1, #numberStr do
                local fChar = numberStr:sub(i, i)
                if string.find(tostring(fChar), "%.") then
                    numberTable[i - 1] = numberTable[i - 1] .. fChar
                    indexToRemove = i
                end
                numberTable[i] = fChar
            end
            if (indexToRemove > 0) then
                table.remove(numberTable, indexToRemove)
            end
            local xOffset = 0
            local withPoint = true
            for i = 1, #numberTable, 1 do
                if i == #numberTable then
                    withPoint = false
                end
                self:drawDigit(layer, x + xOffset, y, withPoint, numberTable[i]);
                xOffset = xOffset + (triangleWidth * 2) + horizontalLineWidth + (triangleWidth * 2) + (lineSpacing * 2)
            end
        end
        function self:drawDigit(layer, xPos, yPos, withPoint, numbToDraw)
            local r, g, b, loffb, lonb, horizontalLineWidth, horizontalLineHeight, triangleWidth, verticalLineWidth, verticalLineHeight, lineSpacing = self.r, self.g, self.b, self.lightOffBrightness, self.lightOnBrightness, self.horizontalLineWidth, self.horizontalLineHeight, self.triangleWidth, self.verticalLineWidth, self.verticalLineHeight, self.lineSpacing
            local defaultx = xPos
            local defaulty = yPos
            local currentBrightness = loffb
            -- Do we need the separator ?
            local drawPt = false
            if #numbToDraw > 1 then
                drawPt = true
                numbToDraw = numbToDraw.sub(numbToDraw, 1, 1)
            end

            -- Draw
            if string.find('02356789', numbToDraw) then
                currentBrightness = lonb
            end
            -- A segment
            setNextFillColor(layer, r, g, b, currentBrightness)
            addBox(layer, xPos, yPos, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos + horizontalLineWidth, yPos, xPos + horizontalLineWidth + triangleWidth, yPos, xPos + horizontalLineWidth, yPos + horizontalLineHeight)
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos, xPos - triangleWidth, yPos, xPos, yPos + horizontalLineHeight)

            -- B segment
            currentBrightness = loffb
            if string.find('01234789', numbToDraw) then
                currentBrightness = lonb
            end
            xPos = defaultx + horizontalLineWidth + lineSpacing
            yPos = defaulty + horizontalLineHeight + lineSpacing
            setNextFillColor(layer, r, g, b, currentBrightness)
            addBox(layer, xPos, yPos, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos + verticalLineWidth, yPos, xPos + verticalLineWidth, yPos - triangleWidth, xPos, yPos)
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos + verticalLineHeight, xPos + verticalLineWidth, yPos + verticalLineHeight, xPos + (verticalLineWidth / 2), yPos + verticalLineHeight + triangleWidth)

            -- C segment
            currentBrightness = loffb
            if string.find('013456789', numbToDraw) then
                currentBrightness = lonb
            end
            yPos = defaulty + horizontalLineHeight + verticalLineHeight + (triangleWidth * 2) + (lineSpacing * 2)
            setNextFillColor(layer, r, g, b, currentBrightness)
            addBox(layer, xPos, yPos, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos, xPos + verticalLineWidth, yPos, xPos + (verticalLineWidth / 2), yPos - triangleWidth)
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos + verticalLineHeight, xPos + verticalLineWidth, yPos + verticalLineHeight, xPos + verticalLineWidth, yPos + verticalLineHeight + triangleWidth)

            -- D segment
            currentBrightness = loffb
            if string.find('023568', numbToDraw) then
                currentBrightness = lonb
            end
            xPos = defaultx
            yPos = yPos + verticalLineHeight + lineSpacing
            setNextFillColor(layer, r, g, b, currentBrightness)
            addBox(layer, xPos, yPos, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos + horizontalLineWidth, yPos + horizontalLineHeight, xPos + horizontalLineWidth + triangleWidth, yPos + horizontalLineHeight, xPos + horizontalLineWidth, yPos)
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos + horizontalLineHeight, xPos - triangleWidth, yPos + horizontalLineHeight, xPos, yPos)

            -- E segment
            currentBrightness = loffb
            if string.find('0268', numbToDraw) then
                currentBrightness = lonb
            end
            xPos = defaultx - triangleWidth - lineSpacing
            yPos = defaulty + horizontalLineHeight + verticalLineHeight + (triangleWidth * 2) + (lineSpacing * 2)
            setNextFillColor(layer, r, g, b, currentBrightness)
            addBox(layer, xPos, yPos, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos, xPos + verticalLineWidth, yPos, xPos + (verticalLineWidth / 2), yPos - triangleWidth)
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos + verticalLineHeight, xPos, yPos + verticalLineHeight + triangleWidth, xPos + verticalLineWidth, yPos + verticalLineHeight)

            -- F segment
            currentBrightness = loffb
            if string.find('045689', numbToDraw) then
                currentBrightness = lonb
            end
            setNextFillColor(layer, r, g, b, currentBrightness)
            yPos = defaulty + horizontalLineHeight + lineSpacing
            addBox(layer, xPos, yPos, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos, xPos, yPos - triangleWidth, xPos + verticalLineWidth, yPos)
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos + verticalLineHeight, xPos + verticalLineWidth, yPos + verticalLineHeight, xPos + (verticalLineWidth / 2), yPos + verticalLineHeight + triangleWidth)

            -- G segment
            currentBrightness = loffb
            if string.find('2345689', numbToDraw) then
                currentBrightness = lonb
            end
            xPos = defaultx
            yPos = defaulty + horizontalLineHeight + verticalLineHeight + triangleWidth - lineSpacing / 2
            setNextFillColor(layer, r, g, b, currentBrightness)
            addBox(layer, xPos, yPos, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos + horizontalLineWidth, yPos, xPos + horizontalLineWidth, yPos + horizontalLineHeight, xPos + horizontalLineWidth + (triangleWidth / 2), yPos + (horizontalLineHeight / 2))
            setNextFillColor(layer, r, g, b, currentBrightness)
            addTriangle(layer, xPos, yPos, xPos, yPos + horizontalLineHeight, xPos - triangleWidth / 2, yPos + (horizontalLineHeight / 2))

            -- point
            currentBrightness = loffb
            if withPoint then
                if drawPt then
                    currentBrightness = lonb
                end
                setNextFillColor(layer, r, g, b, currentBrightness)
                xPos = defaultx + horizontalLineWidth + (triangleWidth * 2) + lineSpacing
                yPos = defaulty + horizontalLineHeight * 2 + verticalLineHeight * 2 + (triangleWidth * 2) + (lineSpacing)
                addCircle(layer, xPos, yPos, triangleWidth / 2)
            end
        end

        function split(s, delimiter)
            result = {}
            for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
                table.insert(result, match);
            end
            return result
        end

        return setmetatable(self, DigitalDisplay)
    end
end

--# Exemple code
--# Getting resolution
local rx, ry = getResolution()
--# Init objects only on the first frame
if not _init then
    redDisplay = DigitalDisplay:new(30, 30, 3, 5, 1, 0, 0, 0.01, 1)
    greenDisplay = DigitalDisplay:new(30, 160, 3, 5, 0, 1, 0, 0.01, 2)
    purpleDisplay = DigitalDisplay:new(30, 290, 3, 10, 247 / 255, 0, 138 / 255, 0.01, 2)
    bigWhiteDisplay = DigitalDisplay:new(30, ry - 200, 4, 2, 1, 1, 1, 0, 2)
    _init = true
end
local testlayer = createLayer()
redDisplay:draw(testlayer, 54.52)
greenDisplay:draw(testlayer, 1980)
purpleDisplay:draw(testlayer, 9000)
bigWhiteDisplay:draw(testlayer, 15)