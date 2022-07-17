Nav:update()

-- Shut down if player not seated (remoteControl protection)
if player.isSeated() == 0 then
    unit.exit()
end

-- Here we are getting the svg codes of the gauges and we are injecting it, the burn Speed is used to make the red zone
local speedValue = getSpeed(construct.getVelocity())
local burnSpeedValue = getSpeed(construct.getFrictionBurnSpeed())
local svg =  _centralTestGauge:draw(tonumber(string.format('%.0f', speedValue)), { burnSpeedValue, 2000 })
svg = svg .. _topLeftTestGauge:draw(tonumber(string.format('%.0f', getFuelLevel(atmofueltank_1))), { 0, 15 })
system.setScreen(svg)
