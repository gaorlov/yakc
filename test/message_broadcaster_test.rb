require 'test_helper'

class MessageBroadcasterTest < Minitest::Test
  def setup
    @broadcaster = YAKC::MessageBroadcaster.new message_parser: TestMessage, instrumenter: TestInstrumenter, publisher: TestPublisher
  end

  def test_broadcaster_instruments
    @broadcaster.handle( "topic", RawMessageGenerator.good_event(event: "instrumented_event") )
    assert_equal "instrumented_event", @broadcaster.instrumenter.message.event
  end

  def test_broadcaster_broadcasts
    @broadcaster.publisher.message = "default"

    @broadcaster.handle( "topic", RawMessageGenerator.good_event(event: "instrumented_event") )
    
    assert_equal "instrumented_event", @broadcaster.publisher.message[:event][:name]
    assert_equal "topic::instrumented_event", @broadcaster.publisher.broadcast_key

  end

  def test_broadcaster_does_not_broadcast_garbage
    @broadcaster.publisher.message = "default"    
    @broadcaster.handle( "topic", RawMessageGenerator.garbage_event )

    assert_equal "default", @broadcaster.publisher.message
  end
end
