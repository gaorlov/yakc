require 'test_helper'

class ReaderTest < Minitest::Test
  def setup
    @broadcaster = YAKC::MessageBroadcaster.new message_parser: TestMessage, instrumenter: TestInstrumenter, publisher: TestPublisher
    @reader = YAKC::Reader.new message_handler: @broadcaster
  end

  def test_sigint_stops_the_read_loop
    
  end
end
