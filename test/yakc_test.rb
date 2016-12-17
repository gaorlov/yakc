require 'test_helper'

class YakcTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Yakc::VERSION
  end

  def test_can_initialize_stack
    handler = YAKC::MessageBroadcaster.new message_parser: TestMessage, instrumenter: TestInstrumenter
    reader = YAKC::Reader.new message_handler: handler
    assert reader
  end

  def test_configuration_is_settable
    refute YAKC.configuration.app

    YAKC.configure do |config|
      config.app = "test"
    end

    assert_equal "test", YAKC.configuration.app
  end
end
