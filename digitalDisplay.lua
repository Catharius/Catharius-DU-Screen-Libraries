--# Add this code in the screen lua content editor
--# Allow you to generate digital display counters
if not DigitalDisplay then

    DigitalDisplay = {}
    DigitalDisplay.__index = DigitalDisplay

    function DigitalDisplay:new(x, y, size, maxdigit, r, g, b)

        local self = {
            x = x or 0,
            y = y or 0,
            size = size or 100,
            maxdigit = maxdigit or 1,
            r = r or 1,
            g = g or 0,
            b = b or 0
        }
        function self:draw(layer)
            local x, y, size, maxdigit, r, g, b = self.x, self.y, self.size, self.maxdigit, self.r, self.g, self.b
            horizontalLineWidth = 10*size
            horizontalLineHeight = 4*size
            triangleWidth = 4*size
            verticalLineWidth = horizontalLineHeight
            verticalLineHeight = horizontalLineWidth
            lineSpacing = 1*size
            defaultx=x
            defaulty=y

            -- A segment
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x+horizontalLineWidth, y, x+horizontalLineWidth+triangleWidth, y, x+horizontalLineWidth, y+horizontalLineHeight)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x-triangleWidth, y, x, y+horizontalLineHeight)

            -- B segment
            x=defaultx+horizontalLineWidth+lineSpacing
            y=defaulty+horizontalLineHeight+lineSpacing
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x+verticalLineWidth, y, x+verticalLineWidth, y-triangleWidth, x, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y+verticalLineHeight, x+verticalLineWidth, y+verticalLineHeight, x+(verticalLineWidth/2), y+verticalLineHeight+triangleWidth)

            -- C segment
            y=defaulty+horizontalLineHeight+verticalLineHeight+(triangleWidth*2)+(lineSpacing*2)
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x+verticalLineWidth, y, x+(verticalLineWidth/2), y-triangleWidth)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y+verticalLineHeight, x+verticalLineWidth, y+verticalLineHeight, x+verticalLineWidth, y+verticalLineHeight+triangleWidth)

            -- D segment
            x=defaultx
            y=y+verticalLineHeight+lineSpacing
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x+horizontalLineWidth, y+horizontalLineHeight, x+horizontalLineWidth+triangleWidth, y+horizontalLineHeight, x+horizontalLineWidth, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y+horizontalLineHeight, x-triangleWidth, y+horizontalLineHeight, x, y)

            -- E segment
            x=defaultx-triangleWidth-lineSpacing
            y=defaulty+horizontalLineHeight+verticalLineHeight+(triangleWidth*2)+(lineSpacing*2)
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x+verticalLineWidth, y, x+(verticalLineWidth/2), y-triangleWidth)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y+verticalLineHeight, x, y+verticalLineHeight+triangleWidth, x+verticalLineWidth, y+verticalLineHeight)

            -- F segment
            setNextFillColor(layer, r, g, b, 1)
            y=defaulty+horizontalLineHeight+lineSpacing
            addBox(layer, x, y, verticalLineWidth, verticalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x, y-triangleWidth, x+verticalLineWidth, y)
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y+verticalLineHeight, x+verticalLineWidth, y+verticalLineHeight, x+(verticalLineWidth/2), y+verticalLineHeight+triangleWidth)

            -- G segment
            x=defaultx
            y=defaulty+horizontalLineHeight+verticalLineHeight+triangleWidth-lineSpacing/2
            setNextFillColor(layer, r, g, b, 1)
            addBox(layer, x, y, horizontalLineWidth, horizontalLineHeight);
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x+horizontalLineWidth, y, x+horizontalLineWidth, y+horizontalLineHeight, x+horizontalLineWidth+(triangleWidth/2), y+(horizontalLineHeight/2))
            setNextFillColor(layer, r, g, b, 1)
            addTriangle(layer, x, y, x, y+horizontalLineHeight, x-triangleWidth/2, y+(horizontalLineHeight/2))
        end

        return setmetatable(self, DigitalDisplay)
    end
end

--# Getting resolution
local rx, ry = getResolution()
if not _init then
    testDisplay = DigitalDisplay:new(rx/2, 10, 10, 1, 1, 0, 0)
    _init = true
end
local testlayer = createLayer()
testDisplay:draw(testlayer)