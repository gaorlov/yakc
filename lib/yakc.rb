require "yakc/version"

module YAKC
  autoload :Configuration,            'yakc/configuration'
  autoload :FallthroughInstrumenter,  'yakc/fallthorugh_instrumenter'
  autoload :MessageBroadcaster,       'yakc/message_broadcaster'
  autoload :Reader,                   'yakc/reader'
  autoload :Message,                  'yakc/message'

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  delegate :logger, to: :configuration
end
