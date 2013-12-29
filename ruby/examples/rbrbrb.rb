$LOAD_PATH.unshift File.dirname(__FILE__)+"/../lib"

require "led_grid"

leds = LedGrid.new(13, 13)

i = 0
while true
	if i.modulo(2) == 0
		leds.fill(r: 255)
	else
		leds.fill(b: 255)
	end

	sleep 0.2

	leds.show

	sleep 0.5
end