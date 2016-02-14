require 'ffi'

module PiPiper
  class Driver

    def initialize
        at_exit { close }
    end

    def close
    end

    def pin_set_pud *args
      raise NotImplementedError
    end
    
    def pin_input *args
      raise NotImplementedError
    end

    def pin_set *args
      raise NotImplementedError
    end

    def pin_output *args
      raise NotImplementedError
    end

    def pin_read *args
      raise NotImplementedError
    end

    def wait_trigger *args
      raise NotImplementedError
    end

    #SPI support...

    def spidev_out *args
      raise NotImplementedError
    end

    def spi_begin *args
      raise NotImplementedError
    end
    
    def spi_end *args
      raise NotImplementedError
    end
    
    def spi_transfer *args
      raise NotImplementedError
    end
    
    def spi_transfernb *args
      raise NotImplementedError
    end
    
    def spi_clock *args
      raise NotImplementedError
    end
    
    def spi_bit_order *args
      raise NotImplementedError
    end
    
    def spi_chip_select *args
      raise NotImplementedError
    end

    def spi_set_data_mode *args
      raise NotImplementedError
    end

    def spi_chip_select_polarity *args
      raise NotImplementedError
    end

    def spi_transfer_bytes *args
      raise NotImplementedError
    end



    #I2C support...
    def i2c_begin *args
      raise NotImplementedError
    end
    
    def i2c_end *args
      raise NotImplementedError
    end
    
    def i2c_write *args
      raise NotImplementedError
    end
    
    def i2c_set_address *args
      raise NotImplementedError
    end
    
    def i2c_set_clock_divider *args
      raise NotImplementedError
    end
    
    def i2c_read *args
      raise NotImplementedError
    end

    def i2c_allowed_clocks *args
      raise NotImplementedError
    end
    
    def i2c_transfer_bytes *args
      raise NotImplementedError
    end
    
    def i2c_read_bytes *args
      raise NotImplementedError
    end
  end
end
