module YAKC
  class Reader
    attr_reader :message_handler, :app, :suffix, :topics

    def initialize( options = {} )
      @message_handler  = options[:message_handler]
      @app              = options[:app]
      @suffix           = options[:suffix]
      @topics           = options[:topics]
    end

    def read
      consumers.map do |consumer|
        results = []

        consumer.fetch do |partition, bulk|
          bulk.each do |message|
            message_handler.handle topic, message
          end
        end
      end
    rescue  Poseidon::Errors::OffsetOutOfRange => e
      YACK.logger.error e
      []
    end

    private

    def consumers
      @consumers ||= topics.map do |topic|
        begin
          Poseidon::ConsumerGroup.new(
          "#{app}-#{topic}-consumer-#{suffix}", 
          config['servers'], 
          config['zookeeper_servers'], 
          topic,
          {})
        rescue => e
          Rails.logger.info e
          nil
        end
      end.compact
    end
  end
end