module YAKC
  class Message
    attr_reader :payload

    def initialize( message )
      @payload = parse( message )
    end

    def broadcastable?
      raise NotImplemented
    end

    def event
      raise NotImplemented
    end

    protected

    def parse( message )
      message
    end
  end
end