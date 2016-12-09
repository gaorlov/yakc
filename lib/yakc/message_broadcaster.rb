module YAKC
  class MessageBroadcaster
    attr_accessor :publisher, :message_class, :instrumenter

    def initialize( publisher: Yeller, instrumenter: FallthroughInstrumenter, message_class: )
      @publisher        = publisher
      @message_class    = message_class
      @instrumenter     = instrumenter
    end

    def handle( topic, message )
      msg = @message_class.new( message )

      @instrumenter.instrument( msg ) do 
        if msg.broadcastable?
          # broadcast the specific topic event 
          @publisher.broadcast msg.payload, broadcast_key( consumer.topic, msg.event )        
        end
      end
    end

    private

    def broadcast_key( topic, event )
      "#{topic}::#{event}"
    end
  end
end