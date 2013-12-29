require "serialport"

class LedGrid
	CMD_SHOW = 0x01
	CMD_CLEAR = 0x02
	CMD_SET = 0x03
	CMD_FILL = 0x04

	attr_accessor :auto_show

	def initialize(height, width, serial_port = nil)
		@height = height
		@width = width

		if serial_port.nil?
			@serial_port = SerialPort.new("/dev/ttyUSB0", 115200, 8, 1, SerialPort::NONE)
		else
			@serial_port = serial_port
		end
		
		@leds = []
	end

	def start_listener
		@listen = true
		@listener_thread = Thread.new do
			puts "listener thread started"
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

		send CMD_SET
		send index
		send_rgb rgb

		show if @auto_show
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
		send CMD_FILL
		send_rgb rgb

		show if @auto_show
	end

	def show()
		send CMD_SHOW
		sleep 0.1
	end

	def clear()
		send CMD_CLEAR
		show if @auto_show
	end

	private
	def coord_to_index(x, y)
		i = y * @width

		if y.modulo(2) == 0
			i + x
		else
			i + @width - x - 1
		end
	end

	def send_rgb(rgb)
		send rgb[:r] || 0x0
		send rgb[:g] || 0x0
		send rgb[:b] || 0x0
	end

	def send(ch)
		@count ||= 0
		@count += 1
		if @count == 40 || ch == CMD_SHOW
			sleep 0.03
			@count = 0
		end

		#puts "> 0x#{ch.to_s(16)}"
		@serial_port.putc ch
	end
end
