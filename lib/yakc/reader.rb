module YAKC
  class Reader
    attr_reader :message_handler

    def initialize( message_handler: )
      @message_handler  = message_handler
      @config           = YAKC.configuration      

      raise KeyError, "YAKC::Reader initialized without a message handler. Please specify one so that your receives messages don't end up on the floor. For more info, go to: https://github.com/gaorlov/yakc#message-handler" unless message_handler
      
      Signal.trap("INT") do
        @terminated = true
      end
    end

    def read
      loop do
        consumers.map do |consumer|
          consumer.fetch do |partition, bulk|
            bulk.each do |message|
              message_handler.handle topic, message
            end
          end
          return if terminated
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