module YAKC
  class FallthroughInstrumenter

    def instrument( message )
      yield
    end
  end
end