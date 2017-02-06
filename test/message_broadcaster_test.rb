require 'test_helper'

class MessageBroadcasterTest < Minitest::Test
  def setup
    @broadcaster = YAKC::MessageBroadcaster.new message_parser: TestMessage, instrumenter: TestInstrumenter
    Subscriber.message        = nil
    Subscriber.broadcast_key  = nil
  end

  def test_broadcaster_instruments
    @broadcaster.handle( "topic", RawMessageGenerator.good_event(event: "instrumented_event") )
    assert_equal "instrumented_event", @broadcaster.instrumenter.message.event
  end

  def test_broadcaster_broadcasts
    Subscriber.message = "default"

    @broadcaster.handle( "topic", RawMessageGenerator.good_event(event: "instrumented_event") )

    assert_equal "instrumented_event", Subscriber.message[:event][:name]
    assert_equal "topic::instrumented_event", Subscriber.broadcast_key

  end

  def test_broadcaster_does_not_broadcast_garbage
    Subscriber.message = "default"    
    @broadcaster.handle( "topic", RawMessageGenerator.garbage_event )

    assert_equal "default", Subscriber.message
  end
end
