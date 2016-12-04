module YAKC
  class Configuration
    attr_accessor :zookeepers, :brokers, :app, :suffix, :topics, :logger

    def initialize
      logger      = Logger.new(STDOUT)
      brokers     = ENV.fetch("BROKERS", "localhost:9092").split(",")
      zookeepers  = ENV.fetch("ZOOKEEPERS", "localhost:2181").split(",") 
      app         = ENV["APP"]
      suffix      = ENV["SUFFIX"]
      topics      = ENV["TOPICS"]
    end
  end
end