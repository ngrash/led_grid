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
#leds.start_listener

#leds.auto_show = true

leds.clear
leds.show

banner.lines.each_with_index do |row, row_index|
  row.chomp.chars.each_with_index do |ch, col_index|
    if ch == '#'
      leds.set(col_index, row_index, { b: 100 })
    end
  end
end

leds.show
#leds.stop_listener
