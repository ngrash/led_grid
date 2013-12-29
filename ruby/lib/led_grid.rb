require "serialport"

class LedGrid
	CMD_SHOW = 0x01
	CMD_CLEAR = 0x02
	CMD_COLOR = 0x03
	CMD_SELECT = 0x04

	attr_accessor :debug_mode

	def initialize(height, width, serial_port = nil)
		@height = height
		@width = width

		if serial_port.nil?
			@serial_port = SerialPort.new("/dev/ttyUSB0", 25000, 8, 1, SerialPort::NONE)
		else
			@serial_port = serial_port
		end
		
		@leds = []
	end

	def start_listener
		@listen = true
		@listener_thread = Thread.new do
			puts "hello from thread"
			while @listen do
				sleep 0.2
				while (output = @serial_port.gets) do
			       puts "< #{output}"
			       sleep 0.2
			    end
			end
		end
	end

	def stop_listener
		@listen = false
		@listener_thread.join
	end

	def [](index)
		@leds[index]
	end

	def []=(index, rgb)
		if index >= 0
			@leds[index] = rgb
		end

		index -= 1

		send CMD_SELECT
		send index
		send CMD_COLOR
		send rgb[:r] || 0x0
		send rgb[:g] || 0x0
		send rgb[:b] || 0x0
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
		send CMD_SHOW
	end

	def clear()
		send CMD_CLEAR
	end

	private
	def coord_to_index(x, y)
		rows = y * @width
		cols = row.modulo(2) == 0 ? x : @width - x
		rows + cols
	end

	def send(ch)
		puts "> #{ch.to_s(16)}"
		@serial_port.putc ch
	end
end