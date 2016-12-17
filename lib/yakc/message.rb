module YAKC
  class Message
    attr_reader :payload

    def initialize( message )
      @payload = parse( message )
    end

    def broadcastable?
      # implement me
    end

    def event
      # implement me
    end

    protected

    def parse( message )
      message
    end
  end
end