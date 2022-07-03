Donut Chart
======
Transform a lua table containing values into a pie chart
![donutChart](https://github.com/Catharius/DU-LUA-LIB-CATHARIUS/blob/master/images/donut.jpg)

### Usage

You can click in the center of the circle to view various data (Sum, Average, Min, Max)
See donutChart.lua for more info. You can copy paste it on an empty screen lua code. The example is at the bottom of the code.

## How to create a chart
### Declaration
```lua
if not alreadyDeclared then
    alreadyDeclared = true
    -- DonutChart:new(posX, posY, circleDiameter, dataUnit)
    -- posX and posY are coordinates of the center of the pie, dataUnit is the value type label (Use the string  "L" for fluids for example) 
    -- Disclaimer : The diameter the chart does not include labels, in order to see the labels on the side, do not use the entire screen width as diameter)
    myDonutChart = DonutChart:new(rx / 2, ry / 2, 400, "kg")
end
```
Why in a if ?  That way we declare the object only once on the first run of the code and not again and again at every frames


### Example
Here is a table data for the example 

|               | My ore stock  |
| ------------- | ------------- |
| Data 1        |            1  |
| Data 2        |           10  |
| Data 3        |           10  |
| Data 4        |           10  |
| Data 5        |           10  |
| Data 6        |           10  |
| Data 7        |           10  |
| Data 8        |           10  |
| Data 9        |           10  |

We pass this data to the draw function as a lua table like this :
```lua
{ {"", "My ore stock"}, {"Data 1",1}, {"Data 2",10} ,  .........    , {"Data 9",10} }
```
The first entry is the header
