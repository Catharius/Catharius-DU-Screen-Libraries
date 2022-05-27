--# Add this code in the screen lua content editor
--# Allow you to generate digital display counters
if not DigitalDisplay then

    DigitalDisplay = {}
    DigitalDisplay.__index = DigitalDisplay

    function DigitalDisplay:new(x, y, size, maxdigit, r, g, b, backcolorRatio)

        local self = {
            x = x or 0,
            y = y or 0,
            size = size or 1,
            maxdigit = maxdigit or 1,
            r = r or 1,
            g = g or 0,
            b = b or 0,
            backcolorRatio = backcolorRatio or 0.09,
            horizontalLineWidth = 10 * size,
            horizontalLineHeight = 4 * size,
            triangleWidth = 4 * size,
            verticalLineWidth = 4 * size,
            verticalLineHeight = 10 * size,
            lineSpacing = 1 * size
        }

        function self:draw(layer, numbertodraw)
            local size, r, g, b, horizontalLineWidth, horizontalLineHeight, triangleWidth, verticalLineWidth, verticalLineHeight, lineSpacing = self.size, self.r, self.g, self.b, self.horizontalLineWidth, self.horizontalLineHeight, self.triangleWidth, self.verticalLineWidth, self.verticalLineHeight, self.lineSpacing

            local setAllToNine = false
            local nbIntegers = 0
            local nbDecimal = 0
            local nbDecimalToKeep = 0
            -- if we have decimals, we count the number of integer and digits
            if string.find(tostring(numbertodraw), ".") then
                split_nb = split(tostring(numbertodraw), "%.")
                nbIntegers = #split_nb[1]
                nbDecimal = #split_nb[2]:gsub("%%", "")
            else
                nbIntegers = #tostring(numbertodraw)
            end
            if nbIntegers > maxdigit then
                -- if we have not enough counters for integer, set all of them to 9
                setAllToNine = true
            else
                if (nbIntegers + nbDecimal) > maxdigit then
                    -- we need to keep a maximum amount of digits
                    nbDecimalToKeep = maxdigit - nbIntegers
                end
            end
            logMessage('int ' .. nbIntegers)
            logMessage('decimal ' .. nbDecimal)
            logMessage('nbDecimalToKeep ' .. nbDecimalToKeep)

            xoffset = 0
            yoffset = 0
            withp = true
            for i = 1, maxdigit, 1 do
                if i == maxdigit then
                    withp = false
                end
                self:drawDigit(layer, x + xoffset, y, withp);
                xoffset = xoffset + (triangleWidth * 2) + horizontalLineWidth + (triangleWidth * 2) + (lineSpacing * 2)
            end
        end
        function self:drawDigit(layer, x, y, withpoint)
            local size, r, g, b, horizontalLineWidth, horizontalLineHeight, triangleWidth, verticalLineWidth, verticalLineHeight, lineSpacing = self.size, self.r, self.g, self.b, self.horizontalLineWidth, self.horizontalLineHeight, self.triangleWidth, self.verticalLineWidth, self.verticalLineHeight, self.lineSpacing
            defaultx = x
            defaulty = y
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            defaultr = r
            defaultg = g
            defaultb = b

            -- A segment
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x + horizontalLineWidth, y, x + horizontalLineWidth + triangleWidth, y, x + horizontalLineWidth, y + horizontalLineHeight)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x - triangleWidth, y, x, y + horizontalLineHeight)

            -- B segment
            x = defaultx + horizontalLineWidth + lineSpacing
            y = defaulty + horizontalLineHeight + lineSpacing
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x + verticalLineWidth, y, x + verticalLineWidth, y - triangleWidth, x, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + verticalLineHeight, x + verticalLineWidth, y + verticalLineHeight, x + (verticalLineWidth / 2), y + verticalLineHeight + triangleWidth)

            -- C segment
            y = defaulty + horizontalLineHeight + verticalLineHeight + (triangleWidth * 2) + (lineSpacing * 2)
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x + verticalLineWidth, y, x + (verticalLineWidth / 2), y - triangleWidth)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + verticalLineHeight, x + verticalLineWidth, y + verticalLineHeight, x + verticalLineWidth, y + verticalLineHeight + triangleWidth)

            -- D segment
            x = defaultx
            y = y + verticalLineHeight + lineSpacing
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x + horizontalLineWidth, y + horizontalLineHeight, x + horizontalLineWidth + triangleWidth, y + horizontalLineHeight, x + horizontalLineWidth, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + horizontalLineHeight, x - triangleWidth, y + horizontalLineHeight, x, y)

            -- E segment
            x = defaultx - triangleWidth - lineSpacing
            y = defaulty + horizontalLineHeight + verticalLineHeight + (triangleWidth * 2) + (lineSpacing * 2)
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x + verticalLineWidth, y, x + (verticalLineWidth / 2), y - triangleWidth)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + verticalLineHeight, x, y + verticalLineHeight + triangleWidth, x + verticalLineWidth, y + verticalLineHeight)

            -- F segment
            setNextFillColor(layer, r, g, b, 1)
            y = defaulty + horizontalLineHeight + lineSpacing
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x, y - triangleWidth, x + verticalLineWidth, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + verticalLineHeight, x + verticalLineWidth, y + verticalLineHeight, x + (verticalLineWidth / 2), y + verticalLineHeight + triangleWidth)

            -- G segment
            x = defaultx
            y = defaulty + horizontalLineHeight + verticalLineHeight + triangleWidth - lineSpacing / 2
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x + horizontalLineWidth, y, x + horizontalLineWidth, y + horizontalLineHeight, x + horizontalLineWidth + (triangleWidth / 2), y + (horizontalLineHeight / 2))
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x, y + horizontalLineHeight, x - triangleWidth / 2, y + (horizontalLineHeight / 2))

            -- point
            if withp then
                setNextFillColor(layer, r, g, b, 1)
                x = defaultx + horizontalLineWidth + (triangleWidth * 2) + lineSpacing
                y = defaulty + horizontalLineHeight * 2 + verticalLineHeight * 2 + (triangleWidth * 2) + (lineSpacing)
                addCircle(layer, x, y, triangleWidth / 2)
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

--# Getting resolution
local rx, ry = getResolution()
if not _init then
    testDisplay = DigitalDisplay:new(rx / 2, 10, 3, 3, 1, 0, 0, 0.09)
    _init = true
end
local testlayer = createLayer()
testDisplay:draw(testlayer, 5.3444)