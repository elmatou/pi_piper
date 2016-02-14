module PiPiper
  class KernelDriver < Driver

    def initialize
      @pins = []
      super
    end

    def close
      release_pins
    end

    #pin support...
    
    def pin_input(pin)
      export(pin)
      pin_direction(pin, 'in')
    end

    def pin_set(pin, value)
      File.open(value_file, 'w') {|f| f.write("#{value}") }
    end

    def pin_output(pin)
      export(pin)
      pin_direction(pin, 'out')
    end

    def pin_read(pin)
      File.read(value_file).to_i
    end

    def wait_for(trigger)
      fd = File.open(value_file, "r")
      File.open(edge_file, "w") { |f| f.write("both") }
      loop do
        fd.read
        IO.select(nil, nil, [fd], nil)
        read
        if changed?
          next if trigger == :rising and value == 0
          next if trigger == :falling and value == 1
          break
        end
      end
    end

private
    def pin_direction(pin, direction)
      File.open("/sys/class/gpio/gpio#{pin}/direction", 'w') do |f|
        f.write(direction)
      end
    end

    # Exports pin and subsequently locks it from outside access
    def export(pin)
      File.open('/sys/class/gpio/export', 'w') { |f| f.write("#{pin}") }
      @pins << pin unless @pins.include?(pin)
    end

    def release_pin(pin)
      File.open('/sys/class/gpio/unexport', 'w') { |f| f.write("#{pin}") }
      @pins.delete(pin)
    end

    def release_pins
      @pins.dup.each { |pin| release_pin(pin) }
    end

    def value_file
      "/sys/class/gpio/gpio#{pin}/value"
    end

    def edge_file
      "/sys/class/gpio/gpio#{pin}/edge"
    end
  end
end
