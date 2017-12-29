port_str = "/dev/ttyUSB0"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.open(port_str, baud_rate, data_bits, stop_bits, parity) do |sp|
  while true do
    sleep 0.2
    while (output = sp.gets) do
      puts "< #{output}"
      sleep 0.2
    end

    print "> "
    binary = gets.chomp.to_i(2)
    puts "Value: 0x#{binary.to_s(16)}"
    sp.putc binary
    sp.flush_output
  end
end
