# DU-LUA-LIB-CATHARIUS
A collection of libraries for implementing renderScripting in dual universe

1 - Donut Chart
======
Transform a lua table containing values into a pie chart
![donutChart](https://raw.githubusercontent.com/Catharius/DU-LUA-LIB-CATHARIUS/master/images/chartExample.jpg)

### Usage

You can click in the center of the circle to view various data (Sum, Average, Min, Max)
See donutChart.lua for more info. You can copy paste it on an empty screen lua code. The example is at the bottom of the code.

## 2 - Digital display
Display numbers with style using segment display
![digitalDisplay](https://raw.githubusercontent.com/Catharius/DU-LUA-LIB-CATHARIUS/master/images/digitalDisplay.jpg)

### Behaviour

The counter will always try to fit a maximum of infos. If there is not enough counters to display a float number it will try to round it. Then it will only display integers and then it will display the maximum available if the integer is too big.

Example with 3 counters i can display : 0.01 to 99.9  but i can't display 10.36 for example. The counter will display 10.4 and if y want to display 2000 it will show 999 instead

Negatives values are not supported

### Usage

See digitalDisplay.lua for more info. You need to copy paste the content of the file at the top of your lua screen code and remove the example at the bottom of the pasted code.

You can also just copy the content of the file into an empty screen to view the example

#### Declare a counter
```lua
if not _init then
    myCounter = DigitalDisplay:new(x, y, sizeRatio, nbDigit, rColor, gColor, bColor, lightOffBrightness, lightOnBrightness)
    _init = true
end
```
- x : x postion of the counter on the sreen using the top left corner of the first digit as ref
- y : y postion of the counter on the screen using the top left corner of the first digit as ref
- sizeRatio : Size of the counter, 1 will show a default size, increase or decrease to scale the counter up and down
- rColor : red color of the counter (use value > 1 to increase brightness)
- gColor : green color of the counter (use value > 1 to increase brightness)
- bColor : blue color of the counter (use value > 1 to increase brightness)
- lightOffBrightness : Control opacity of unused number segments (Use 0 to hide them completely)
- lightOnBrightness : Same with active number segments (I have used this method because using color attributes was bugged at the moment)

The declaration is made inside a "if" because we want to declare it only once and not at every frames

#### Set a counter value
```lua
myCounter:draw(aLayer, myValue)
```
- aLayer : a layer (see example to create one)
- myValue : A positive value (integer or float)

