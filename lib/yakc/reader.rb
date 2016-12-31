module YAKC
  class Reader
    attr_reader :message_handler, :terminated, :config
    delegate :topics, :brokers, :zookeepers, :logger, :app, :suffix, to: :config

    def initialize( message_handler: )
      @message_handler  = message_handler
      @config           = YAKC.configuration     

      raise KeyError, "YAKC::Reader initialized without a message handler. Please specify one so that your receives messages don't end up on the floor. For more info, go to: https://github.com/gaorlov/yakc#message-handler" unless message_handler
      
      %w(INT TERM).each do |signal|
        Signal.trap(signal) do
          @terminated = true
        end
      end
    end

    def read
      logger.info "YAKC: Starting reading"
      loop do
        consumers.map do |consumer|
          consumer.fetch do |partition, bulk|
            bulk.each do |message|
              message_handler.handle consumer.topic, message
            end
          end
          return if terminated
        end
        return if terminated
      end
    rescue => e
      logger.error e
      retry
    end

    private

    def consumers
      @consumers ||= topics.map do |topic|
        Poseidon::ConsumerGroup.new(
        "#{app}-#{topic}-consumer-#{suffix}", 
        brokers,
        zookeepers, 
        topic,
        {})
      end
    end
  end
end