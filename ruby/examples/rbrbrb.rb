$LOAD_PATH.unshift File.dirname(__FILE__)+"/../lib"

require "led_grid"

leds = LedGrid.new(13, 13)
leds.start_listener

i = 0
while true
  puts "##{i}"

  if i.modulo(2) == 0
    leds.fill(r: 255)
  else
    leds.fill(b: 255)
  end

  leds.show

  sleep 1 / 35

  i += 1
end

leds.stop_listener
