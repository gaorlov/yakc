module YAKC
  class MessageBroadcaster
    attr_accessor :publisher, :message_class

    def initialize(options= {})
      @publisher        = options[:publisher] || Yeller
      @message_class = options[:message_class]
    end

    def handle( topic, message )
      msg = @message_class.new( message )
      if msg.broadcastable?
        # broadcast the specific topic event 
        @publisher.broadcast msg.payload, broadcast_key( consumer.topic, msg.event )
        
        # broadcast that AN event happened on the topic for generic topic consumers
        @publisher.broadcast msg.payload, broadcast_key( consumer.topic, "*" )
      end
    end

    private

    def broadcast_key( topic, event )
      "#{topic}::#{event}"
    end
  end
end