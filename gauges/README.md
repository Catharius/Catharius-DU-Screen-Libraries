
Gauges
======
Create a gauge to show a value
![circularGauge](https://github.com/Catharius/DU-LUA-LIB-CATHARIUS/blob/master/images/cgauge.jpg)

## How to create a circularGauge
### Declaration
```lua
-- Declared only once
if not alreadyDeclared then
    alreadyDeclared = true
    -- Gauge:new(posX, posY, circleDiameter, graduationValue, NbOfGraduation, gaugeLabel1, gaugeLabel2)

    -- Here i want a gauge with graduations 100 by 100 and 10 graduations so from 0 to 1000
    testGauge = CircularGauge:new(rx / 2, ry / 2, 400, 100, 10, "Current Speed", "km/h")
end
```
You will find an example in the circularGauge.lua file (code to be pasted into the lua part of a screen)
