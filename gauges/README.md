
Gauges
======
Create a gauge to show a value

NEW : You can now also use this lib on your hud instead of screen. See [circularGaugeHudVersion.lua](circularGaugeHudVersion.lua) for lib and 
[hudExample](hudExample)

![circularGauge](https://github.com/Catharius/DU-LUA-LIB-CATHARIUS/blob/master/images/cgauge2.jpg)

## How to create a circular gauge
### Declaration
```lua
-- Declared only once
if not alreadyDeclared then
    alreadyDeclared = true
    -- CircularGauge:new(posX, posY, circleDiameter, graduationValue, nbOfGraduation, gaugeLabel1, gaugeLabel2, gaugeType)

    -- Here i want a gauge with graduations 200 by 200 and 10 graduations so from 0 to 2000
    centralTestGauge = CircularGauge:new(rx / 2, ry / 2, 400, 200, 10, "Current Speed", "km/h", CircularGauge.FULL)
end
-- Here i want to draw the centralGauge, i pass 50 km/h as value (This is an example, the real data should be passed from the piloting seat to the screen)
-- Since i want to see if i will burn if i'm speeding too much i want to setup a red zone on the circle to indicate that i'm in danger of dying
-- Let's say from 1850 to max (here it is 2000)
centralTestGauge:draw(50, { 1850, 2000 })
```
You will find an example in the circularGauge.lua file (code to be pasted into the lua part of a screen)

- posX : X position of the center of the gauge on the screen
- posY : Y position of the center of the gauge on the screen
- circleDiameter : Size of the gauge
- graduationValue : The value of the first graduation, for example 100 will create a gauge with 100,200,300 etc...
- nbOfGraduation : Number of wanted graduation, if i want 10 graduations of 100 it will go to 1000 max
- gaugeLabel1 : gauge label
- gaugeLabel2 : Second line of gauge label 
- gaugeType : type of gauge, use CircularGauge.THE_WANTED_TYPE (See next chapter for the possible values)


### Gauge types
There are several types to choose from (FULL, HALF, HALF_LEFT, HALF_RIGHT,QUARTER, QUARTER_LEFT, QUARTER_TOP_LEFT, QUARTER_BOTTOM_LEFT, QUARTER_RIGHT, QUARTER_BOTTOM_RIGHT, QUARTER_TOP_RIGHT)

### Additional feature

It is possible to make a red zone on the counter, it can be done by passing arguments to the draw method (see lua example)
