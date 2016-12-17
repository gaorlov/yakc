require 'test_helper'

class ReaderTest < Minitest::Test
  def setup
    @broadcaster = YAKC::MessageBroadcaster.new message_parser: TestMessage, instrumenter: TestInstrumenter, publisher: TestPublisher
    @reader = YAKC::Reader.new message_handler: @broadcaster
  end

  def test_sigint_stops_the_read_loop
    refute @reader.terminated
    Thread.new do
      @reader.read
    end
    sleep 0.1
    Process.kill "INT", Process.pid
    assert @reader.terminated
  end
end
