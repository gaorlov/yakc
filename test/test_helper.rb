$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'yakc'

require 'minitest/autorun'

class TestMessage < YAKC::Message
  attr_reader :payload
  
  def broadcastable?
    event.present?
  end

  def event
    message[:event][:name]
  rescue
    nil
  end

  protected

  def parse( message )
    message
  end
end

handler = YAKC::MessageBroadcaster.new message_class: TestMessage
