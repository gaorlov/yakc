module YAKC
  module Instrumenter
    class FallthroughInstrumenter

      def instrument( message )
        yield
      end
    end
  end
end