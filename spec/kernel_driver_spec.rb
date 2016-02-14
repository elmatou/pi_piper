describe 'Bcm2835Driver' do
  context 'Pin extention' do
    context 'given a pin is released' do
    around(:example) do |example|
       Platform.driver = StubDriver.new.tap do |d|
           example.run
       end
     end

      it 'should actually release it' do
        expect(Platform.driver).to receive(:release_pin).with(4)
     
        pin = Pin.new(pin: 4, direction: :in)
        pin.release
        expect(pin.released?).to be(true)
      end

      it 'should not mark unreleased pins as released' do
        pin = Pin.new(pin: 4, direction: :in)
        expect(pin.released?).to be(false)
      end

      it 'should not continue to use the pin' do
        expect(Platform.driver).to receive(:release_pin).with(4)

        pin = Pin.new(pin: 4, direction: :in)
        pin.release

        expect { pin.read }.to raise_error(PinError, 'Pin 4 already released')
        expect { pin.on }.to raise_error(PinError, 'Pin 4 already released')
        expect { pin.off }.to raise_error(PinError, 'Pin 4 already released')
        expect { pin.pull!(:up) }.to(
          raise_error(PinError, 'Pin 4 already released'))
      end
    end
  end
end