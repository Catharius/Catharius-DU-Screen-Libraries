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
            backcolorRatio = backcolorRatio or 0.05,
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
            if string.find(tostring(numbertodraw), "%.") then
                split_nb = split(tostring(numbertodraw), "%.")
                nbIntegers = #split_nb[1]:gsub("%%", "")
                if split_nb[2] then
                    nbDecimal = #split_nb[2]:gsub("%%", "")
                end
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
                else
                    nbDecimalToKeep = nbDecimal
                end
            end
            if nbDecimalToKeep > 0 then
                --Rounding the number
                numbertodraw = tonumber(string.format('%.'..nbDecimalToKeep..'f', numbertodraw))
            else
                --Round
                numbertodraw = tonumber(string.format('%.0f', numbertodraw))
            end
            local numberstr = ''
            if setAllToNine then
                for i = 1, maxdigit, 1 do
                    numberstr = numberstr..'9'
                end
            else
                local numberpadding = maxdigit - (nbIntegers + nbDecimalToKeep)
                -- Case when we have more counters than numbers to display
                if numberpadding>0 then
                    for i=1, numberpadding, 1 do
                        numberstr = numberstr..'X'
                    end
                    numberstr = numberstr..numbertodraw
                else
                    -- Everything is ok
                    numberstr = numbertodraw
                end
            end
            --Put the string into a table
            local numbertable={}
            numberstr = tostring(numberstr)
            local indexToRemove = 0
            for i = 1, #numberstr do
                local fchar =  numberstr:sub(i, i)
                if string.find(tostring(fchar), "%.") then
                    numbertable[i-1]=numbertable[i-1]..fchar
                    indexToRemove = i
                else
                    numbertable[i] = fchar
                end
            end
            if(indexToRemove>0) then
                table.remove(numbertable, indexToRemove)
            end
            xoffset = 0
            yoffset = 0
            withp = true
            for i = 1, #numbertable, 1 do
                if i == #numbertable then
                    withp = false
                end
                self:drawDigit(layer, x + xoffset, y, withp, numbertable[i]);
                xoffset = xoffset + (triangleWidth * 2) + horizontalLineWidth + (triangleWidth * 2) + (lineSpacing * 2)
            end
        end
        function self:drawDigit(layer, x, y, withpoint, numbToDraw)
            local size, r, g, b, horizontalLineWidth, horizontalLineHeight, triangleWidth, verticalLineWidth, verticalLineHeight, lineSpacing = self.size, self.r, self.g, self.b, self.horizontalLineWidth, self.horizontalLineHeight, self.triangleWidth, self.verticalLineWidth, self.verticalLineHeight, self.lineSpacing
            local defaultx = x
            local defaulty = y
            local defaultr = r
            local defaultg = g
            local defaultb = b
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            -- Do we need the separator ?
            local drawPt = false
            if #numbToDraw>1 then
                drawPt = true
                numbToDraw=numbToDraw.sub(numbToDraw, 1, 1)
            end

            -- Draw
            if string.find('02356789', numbToDraw) then
                r = defaultr
                g = defaultg
                b = defaultb
            end
            -- A segment
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x + horizontalLineWidth, y, x + horizontalLineWidth + triangleWidth, y, x + horizontalLineWidth, y + horizontalLineHeight)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x - triangleWidth, y, x, y + horizontalLineHeight)

            -- B segment
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            if string.find('01234789', numbToDraw) then
                r = defaultr
                g = defaultg
                b = defaultb
            end
            x = defaultx + horizontalLineWidth + lineSpacing
            y = defaulty + horizontalLineHeight + lineSpacing
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x + verticalLineWidth, y, x + verticalLineWidth, y - triangleWidth, x, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + verticalLineHeight, x + verticalLineWidth, y + verticalLineHeight, x + (verticalLineWidth / 2), y + verticalLineHeight + triangleWidth)

            -- C segment
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            if string.find('013456789', numbToDraw) then
                r = defaultr
                g = defaultg
                b = defaultb
            end
            y = defaulty + horizontalLineHeight + verticalLineHeight + (triangleWidth * 2) + (lineSpacing * 2)
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x + verticalLineWidth, y, x + (verticalLineWidth / 2), y - triangleWidth)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + verticalLineHeight, x + verticalLineWidth, y + verticalLineHeight, x + verticalLineWidth, y + verticalLineHeight + triangleWidth)

            -- D segment
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            if string.find('023568', numbToDraw) then
                r = defaultr
                g = defaultg
                b = defaultb
            end
            x = defaultx
            y = y + verticalLineHeight + lineSpacing
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x + horizontalLineWidth, y + horizontalLineHeight, x + horizontalLineWidth + triangleWidth, y + horizontalLineHeight, x + horizontalLineWidth, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + horizontalLineHeight, x - triangleWidth, y + horizontalLineHeight, x, y)

            -- E segment
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            if string.find('0268', numbToDraw) then
                r = defaultr
                g = defaultg
                b = defaultb
            end
            x = defaultx - triangleWidth - lineSpacing
            y = defaulty + horizontalLineHeight + verticalLineHeight + (triangleWidth * 2) + (lineSpacing * 2)
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x + verticalLineWidth, y, x + (verticalLineWidth / 2), y - triangleWidth)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + verticalLineHeight, x, y + verticalLineHeight + triangleWidth, x + verticalLineWidth, y + verticalLineHeight)

            -- F segment
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            if string.find('045689', numbToDraw) then
                r = defaultr
                g = defaultg
                b = defaultb
            end
            setNextFillColor(layer, r, g, b, 1)
            y = defaulty + horizontalLineHeight + lineSpacing
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x, y - triangleWidth, x + verticalLineWidth, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y + verticalLineHeight, x + verticalLineWidth, y + verticalLineHeight, x + (verticalLineWidth / 2), y + verticalLineHeight + triangleWidth)

            -- G segment
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            if string.find('2345689', numbToDraw) then
                r = defaultr
                g = defaultg
                b = defaultb
            end
            x = defaultx
            y = defaulty + horizontalLineHeight + verticalLineHeight + triangleWidth - lineSpacing / 2
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x + horizontalLineWidth, y, x + horizontalLineWidth, y + horizontalLineHeight, x + horizontalLineWidth + (triangleWidth / 2), y + (horizontalLineHeight / 2))
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x, y + horizontalLineHeight, x - triangleWidth / 2, y + (horizontalLineHeight / 2))

            -- point
            r = r * backcolorRatio
            g = g * backcolorRatio
            b = b * backcolorRatio
            if withp then
                if drawPt then
                    r = defaultr
                    g = defaultg
                    b = defaultb
                end
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

--# Exemple code to show speed
-- Import data
local json = require("dkjson")
local data = json.decode(getInput()) or {}
local currentSpeed = math.floor(data.speed)


--# Getting resolution
local rx, ry = getResolution()
if not _init then
    testDisplay = DigitalDisplay:new(10, 10, 3, 5, 1, 0, 0, 0.01)
    _init = true
end
local testlayer = createLayer()
testDisplay:draw(testlayer, currentSpeed)