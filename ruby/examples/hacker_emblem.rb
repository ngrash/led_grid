$LOAD_PATH.unshift File.dirname(__FILE__)+"/../lib"

require "led_grid"

banner = <<-banner
    ###    
    ###    
    ###    

        ###
        ###
        ###

### ### ###
### ### ###
### ### ###
banner

leds = LedGrid.new(13, 13)
leds.start_listener

sleep 1

leds.clear
leds.show

banner.chars.each_with_index do |ch, i|
	leds[i] = { b: 100 } if ch == '#'

	leds.show if i.modulo(10) == 0

	sleep 0.5
end

leds.show
leds.stop_listener