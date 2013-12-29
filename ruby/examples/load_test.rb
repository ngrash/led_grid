$LOAD_PATH.unshift File.dirname(__FILE__)+"/../lib"

require "led_grid"

leds = LedGrid.new(13, 13)

while true
	leds.show
	leds.clear

	13.times do |x|
		13.times do |y|
			leds.set(x, y, r: 10 * y, g: 130 - 10 * y)
		end
	end
end