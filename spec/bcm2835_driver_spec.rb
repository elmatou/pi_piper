describe 'Bcm2835Driver' do
  around(:example) do |example|
     Platform.driver = StubDriver.new.tap do |d|
         example.run
     end
  end
end