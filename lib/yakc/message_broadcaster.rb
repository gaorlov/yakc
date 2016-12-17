module YAKC
  class MessageBroadcaster
    attr_accessor :publisher, :message_class, :instrumenter

    def initialize( publisher: Yeller, instrumenter: FallthroughInstrumenter, message_parser: )
      @publisher        = publisher
      @message_class    = message_parser
      @instrumenter     = instrumenter.new
      raise "MessageBroadcaster must have a valid message class" unless @message_class
    end

    def handle( topic, message )
      msg = @message_class.new( message )

      @instrumenter.instrument( msg ) do 
        if msg.broadcastable?
          # broadcast the specific topic event 
          @publisher.broadcast msg.payload, broadcast_key( topic, msg.event )        
        end
      end
    end

    private

    def broadcast_key( topic, event )
      "#{topic}::#{event}"
    end
  end
end