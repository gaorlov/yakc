require "yakc/version"
require 'active_support'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object'
require 'active_support/notifications'

module YAKC
  autoload :Configuration,            'yakc/configuration'
  autoload :FallthroughInstrumenter,  'yakc/fallthrough_instrumenter'
  autoload :MessageBroadcaster,       'yakc/message_broadcaster'
  autoload :Reader,                   'yakc/reader'
  autoload :Message,                  'yakc/message'

  class << self
    attr_writer :configuration
  end

  def self.configure
    yield configuration
  end
  
  def self.configuration
    @configuration ||= YAKC::Configuration.new
  end

  delegate :logger, to: :configuration
end
