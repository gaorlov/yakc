module YAKC
  class MessageBroadcaster
    attr_accessor :pubsub, :translator

    def initialize(options= {})
      @pubsub     = options[:pubsub]      || Yeller
      @translator = options[:translator]  || YACK::Translator::AvroTranslator
    end

    def handle( topic, message )
      msg = @translator.translate( message )
      if broadcastable? msg
        @pubsub.broadcast msg, broadcast_key(consumer.topic, msg)
        @pubsub.broadcast msg, generic_broadcast_key(consumer.topic, msg)
      end
    end

    private

    def broadcast_key( topic, message )
      key_for topic, message["event"]["name"]
    end

    def generic_broadcast_key( topic, message )
      key_for topic, "*"
    end

    def key_for(topic, event)
      "#{topic}::#{event}"
    end

    def broadcastable?( message )
      message["event"] && message["event"]["name"]
    end
  end
end