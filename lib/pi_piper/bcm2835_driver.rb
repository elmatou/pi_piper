
module PiPiper
  # The Bcm2835 module is not intended to be directly called.
  # It serves as an FFI library for PiPiper::SPI & PiPiper::I2C.
  class Bcm2835Driver < Driver
    require 'ffi'
    extend FFI::Library
    ffi_lib File.dirname(__FILE__) + '/libbcm2835.so'

    def initialize
      init
      super
    end

    attach_function :init, :bcm2835_init, [], :uint8
    attach_function :close, :bcm2835_close, [], :uint8

    #pin support...

    # Sets the Pull-up/down mode for the specified pin.
    attach_function :gpio_set_pud,         :bcm2835_gpio_set_pud, [:uint8, :uint8], :void

    # Sets the Function Select register for the given pin, which configures the pin as Input, Output or one of the 6 alternate functions.
    attach_function :gpio_select_function, :bcm2835_gpio_fsel,    [:uint8, :uint8], :void
    attach_function :gpio_set,             :bcm2835_gpio_set,     [:uint8], :void
    attach_function :gpio_clear,           :bcm2835_gpio_clr,     [:uint8], :void
    attach_function :gpio_level,           :bcm2835_gpio_lev,     [:uint8], :uint8
    
    def pin_input(pin)
      gpio_select_function(pin, PinValues::GPIO_FSEL_INPT)
    end

    def pin_output(pin)
      gpio_select_function(pin, PinValues::GPIO_FSEL_OUTP)
    end

    def pin_set_pud(pin, value)
      gpio_set_pud(pin, value)
    end

    def pin_set(pin, value)
      value == 0 ? gpio_clear(pin) : gpio_set(pin)
      value
    end
    
    def pin_read(pin)
      gpio_level(pin) == PinValues::GPIO_HIGH
    end



    #SPI support...

    SPI_MODE0 = 0
    SPI_MODE1 = 1
    SPI_MODE2 = 2
    SPI_MODE3 = 3

    attach_function :spi_begin,       :bcm2835_spi_begin,            [], :uint8
    attach_function :spi_end,         :bcm2835_spi_end,              [], :uint8
    attach_function :spi_transfer,    :bcm2835_spi_transfer,         [:uint8], :uint8
    attach_function :spi_transfernb,  :bcm2835_spi_transfernb,       [:pointer, :pointer, :uint], :void
    attach_function :spi_clock,       :bcm2835_spi_setClockDivider,  [:uint8], :void
    attach_function :spi_bit_order,   :bcm2835_spi_setBitOrder,      [:uint8], :void
    attach_function :spi_chip_select, :bcm2835_spi_chipSelect,       [:uint8], :void
    attach_function :spi_set_data_mode, :bcm2835_spi_setDataMode,    [:uint8], :void
    attach_function :spi_chip_select_polarity, 
                    :bcm2835_spi_setChipSelectPolarity,              [:uint8, :uint8], :void

    #NOTE to use: chmod 666 /dev/spidev0.0
    def spidev_out(array)
      File.open('/dev/spidev0.0', 'wb'){|f| f.write(array.pack('C*')) }
    end

    def spi_transfer_bytes(data)
      data_out = FFI::MemoryPointer.new(data.count)
      data_in = FFI::MemoryPointer.new(data.count)
      (0..data.count-1).each { |i| data_out.put_uint8(i, data[i]) }

      spi_transfernb(data_out, data_in, data.count)

      (0..data.count-1).map { |i| data_in.get_uint8(i) }
    end



    #I2C support...
    I2C_REASON_OK         = 0  #Success
    I2C_REASON_ERROR_NACK = 1  #Received a NACK
    I2C_REASON_ERROR_CLKT = 2  #Received Clock Stretch Timeout
    I2C_REASON_ERROR_DATA = 3  #Not all data is sent / received

    attach_function :i2c_begin,      :bcm2835_i2c_begin,             [], :void
    attach_function :i2c_end,        :bcm2835_i2c_end,               [], :void
    attach_function :i2c_write,      :bcm2835_i2c_write,             [:pointer, :uint], :uint8
    attach_function :i2c_set_address,:bcm2835_i2c_setSlaveAddress,   [:uint8], :void
    attach_function :i2c_set_clock_divider, :bcm2835_i2c_setClockDivider,     [:uint16], :void
    attach_function :i2c_read,       :bcm2835_i2c_read,              [:pointer, :uint], :uint8

    def i2c_allowed_clocks
      [100.kilohertz,
       399.3610.kilohertz,
       1.666.megahertz,
       1.689.megahertz]
    end

    def i2c_transfer_bytes(data)
      data_out = FFI::MemoryPointer.new(data.count)
      (0..data.count-1).each{ |i| data_out.put_uint8(i, data[i]) } 

      i2c_write data_out, data.count
    end

    def i2c_read_bytes(bytes)
      data_in = FFI::MemoryPointer.new(bytes)
      i2c_read(data_in, bytes) #TODO reason codes 

      (0..bytes-1).map { |i| data_in.get_uint8(i) } 
    end
  end
end
