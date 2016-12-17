require "yakc/version"
require 'active_support'
require 'active_support/core_ext/module/delegation'
require 'yeller'

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
