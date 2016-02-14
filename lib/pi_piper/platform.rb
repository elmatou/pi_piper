module PiPiper

  #Hardware abstraction manager. Not intended for direct use.
  class Platform
    @@driver = nil

    PiPiper.autoload(:KernelDriver, 'pi_piper/kernel_driver')
    PiPiper.autoload(:Driver, 'pi_piper/driver')
    PiPiper.autoload(:StubDriver, 'pi_piper/stub_driver')
    PiPiper.autoload(:Bcm2835Driver, 'pi_piper/bcm2835_driver')
    PiPiper.autoload(:WiringPiDriver, 'pi_piper/wiringpi_driver')

    #gets the current platform driver. Defaults to BCM2835.
    def self.driver
      @@driver ||= PiPiper::Bcm2835.new # PiPiper::Driver.new, PiPiper::KernelDriver.new
    end

    def self.driver=(instance)
      @@driver = instance
    end
  end
end
