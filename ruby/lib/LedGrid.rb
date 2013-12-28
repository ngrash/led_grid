require "serialport"

class LedGrid
	CMD_SHOW = 0x01
	CMD_CLEAR = 0x02
	CMD_COLOR = 0x03
	CMD_SELECT = 0x04

	def initialize(height, width, serial_port = nil)
		@height = height
		@width = width

		if serial_port.nil?
			@serial_port = SerialPort.new("/dev/ttyUSB0", 9600, 8, 1, SerialPort::NONE)
		else
			@serial_port = serial_port
		end
		
		@leds = []
	end

	def [](index)
		@leds[index]
	end

	def []=(index, rgb)
		if index >= 0
			@leds[index] = rgb
		end
		@serial_port.putc CMD_SELECT
		@serial_port.putc index
		@serial_port.putc CMD_COLOR
		@serial_port.putc rgb[:r]
		@serial_port.putc rgb[:g]
		@serial_port.putc rgb[:b]
	end

	def get(x, y)
		index = coord_to_index(x, y)
		puts index
		@leds[index]
	end

	def set(x, y, rgb)
		index = coord_to_index(x, y)
		puts index
		self.[]=(index, rgb)
	end

	def fill(rgb)
		self.[]=(-1, rgb)
	end

	def show()
		@serial_port.putc CMD_SHOW
	end

	def clear()
		@serial_port.putc CMD_CLEAR
	end

	private
	def coord_to_index(x, y)
		y * @width + x
	end
end