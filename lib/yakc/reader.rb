module YAKC
  class Reader
    attr_reader :message_handler

    def initialize( options = {} )
      @message_handler  = options.delete( :message_handler ){|_| raise KeyError, "YAKC::Reader initialized without a message handler. Please specify one so that your receives messages don't end up on the floor. For more info, go to: https://github.com/gaorlov/yakc#message-handler" }
      @config           = YAKC.configuration
    end

    def read
      consumers.map do |consumer|
        consumer.fetch do |partition, bulk|
          bulk.each do |message|
            message_handler.handle topic, message
          end
        end
      end
    rescue => e
      YACK.logger.error e
    end

    private

    def consumers
      @consumers ||= topics.map do |topic|
        begin
          Poseidon::ConsumerGroup.new(
          "#{app}-#{topic}-consumer-#{suffix}", 
          @config.brokers,
          @config.zookeepers, 
          topic,
          {})
        rescue => e
          YAKC.logger.error e
          nil
        end
      end.compact
    end
  end
end