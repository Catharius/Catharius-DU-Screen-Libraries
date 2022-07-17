-- Add this code at the end of the start

-- Hide the helper and configure screen
system.showHelper(false)
system.showScreen(1)

-- Get screen dimensions
local width = system.getScreenWidth()
local height = system.getScreenHeight()

-- Declaring gauges
-- I declare a half gauge positionned in the middle of the screen, at the bottom minus 10 px  and if should have a width of 1/4 of the screen
-- One graduation is 200, with 10 graduations
_centralTestGauge = CircularGauge:new(width / 2, height-10 , width / 4, 200, 10, "Current Speed", "km/h", CircularGauge.HALF)

-- I declare a fuel gauge positionned at the top left corner of the screen, 10 graduaton of 10
_topLeftTestGauge = CircularGauge:new(40, 40, 300, 10, 10, "Nitron", "%", CircularGauge.QUARTER_TOP_LEFT)
