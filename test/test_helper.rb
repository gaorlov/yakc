$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'yakc'

require 'minitest/autorun'

class RawMessageGenerator
  class << self
    def good_event( event: "default" )
      {
        event:{
          name: event,
          timestamp: Time.now
        },
        object_id: Random.rand(1_000),
        object_value: value
      }
    end

    def garbage_event
      {}
    end

    private

    def value
      values = [ "whatever", "something", "somethign else", "wow", "such value", "this is important", "value", "great value", "great value: more value, more greater"]
      values.sample(1).first
    end
  end
end

class TestMessage < YAKC::Message
  attr_reader :payload
  
  def broadcastable?
    event.present?
  end

  def event
    payload[:event][:name]
  rescue
    nil
  end
end

class TestInstrumenter
  attr_accessor :message
  def instrument( message )
    @message = message
    yield
  end
end

class TestPublisher
  class << self
    attr_accessor :message, :broadcast_key
    def broadcast( message, broadcast_key )
      @message = message
      @broadcast_key = broadcast_key
    end
  end
end