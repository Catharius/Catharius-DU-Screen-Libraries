# DU-LUA-LIB-CATHARIUS
A collection of libraries for implementing renderScripting in dual universe

## Digital display

Display numbers with style using segment display
![digitalDisplay](https://raw.githubusercontent.com/Catharius/DU-LUA-LIB-CATHARIUS/master/images/digitalDisplay.jpg?token=GHSAT0AAAAAABTWXVRXMDFQ4HOX4RC7U5EGYUTVBHA)

### Behaviour

The counter will always try to fit a maximum of infos. If there is not enough counters to display a float number it will try to round it. Then it will only display integers and then it will display the maximum available if the integer is too big.

Example with 3 counters i can display : 0.01 to 99.9  but i can't display 10.36 for example. The counter will display 10.4 and if y want to display 2000 it will show 999 instead

Negatives values are not supported


### Usage

See digitalDisplay.lua for more info. You need to copy paste the content of the file at the top of your lua screen code and remove the example at the bottom of the pasted code.

You can also just copy the content of the file into an empty screen to view the example
