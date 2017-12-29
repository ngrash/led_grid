require "serialport"

class LedGrid
  CMD_SHOW  = 0x01
  CMD_CLEAR = 0x02
  CMD_SET   = 0x03
  CMD_FILL  = 0x04
  CMD_FRAME = 0x05
  CMD_DUMP  = 0x06

  def initialize(height, width, serial_port = nil)
    @height = height
    @width = width

    if serial_port.nil?
      @serial_port = SerialPort.new("/dev/ttyUSB0", 19200, 8, 1, SerialPort::NONE)
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

  def get(index)
    @leds[index]
  end

  def set(index, rgb)
    @leds[index] = rgb
  end

  def get(x, y)
    index = coord_to_index(x, y)
    @leds[index]
  end

  def set(x, y, rgb)
    index = coord_to_index(x, y)
    @leds[index] = rgb
  end

  def fill(rgb)
    send CMD_FILL
    send_rgb rgb
  end

  def show()
    frame(@leds)
  end

  def clear()
    @leds = []
    send CMD_CLEAR
  end

  def frame(rgbs)
    send CMD_FRAME

    (@width * @height).times.each do |i|
      r = i / @width
      if r.modulo(2) == 0
        send_rgb rgbs[i] || {}
      else
        c = i % @width
        send_rgb rgbs[i - 2 * c + @width - 1] || {}
      end
    end
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
    @cmd_counter ||= 0
    @cmd_counter += 1

    puts "> 0x#{ch.to_s(16)}"
    @serial_port.putc ch
  end
end
