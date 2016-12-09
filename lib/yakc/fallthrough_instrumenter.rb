module YAKC
  module Instrumenter
    class FallthroughInstrumenter < Base

      def instrument( message )
        yield
      end
    end
  end
end