module YAKC
  class MessageBroadcaster
    attr_accessor :message_class, :instrumenter

    def initialize( instrumenter: FallthroughInstrumenter, message_parser: )
      @message_class    = message_parser
      @instrumenter     = instrumenter.new
      raise "MessageBroadcaster must have a valid message class" unless @message_class
    end

    def handle( topic, message )
      msg = @message_class.new( message )

      @instrumenter.instrument( msg ) do 
        if msg.broadcastable?
          # broadcast the specific topic event 
          ActiveSupport::Notifications.instrument broadcast_key( topic, msg.event ), message: msg.payload
        end
      end
    end

    private

    def broadcast_key( topic, event )
      "#{topic}::#{event}"
    end
  end
end