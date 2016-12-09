module YAKC
  class Reader
    attr_reader :message_handler

    def initialize( options = {} )
      @message_handler  = options.delete( :message_handler ){|_| raise KeyError, "YAKC::Reader initialized without a message handler. Please specify one so that your receives messages don't end up on the floor. For more info, go to: https://github.com/gaorlov/yakc#message-handler" }
      @config           = YAKC.configuration      
      
      Signal.trap("INT") do
        self.class.terminated = true
      end
    end

    def read
      loop do
        consumers.map do |consumer|
          consumer.fetch do |partition, bulk|
            bulk.each do |message|
              message_handler.handle topic, message
            end
            return if terminated
          end
        end
      end
    rescue => e
      YACK.logger.error e
      retry
    end

    private

    def consumers
      @consumers ||= topics.map do |topic|
        Poseidon::ConsumerGroup.new(
        "#{app}-#{topic}-consumer-#{suffix}", 
        @config.brokers,
        @config.zookeepers, 
        topic,
        {})
      end
    end
  end
end