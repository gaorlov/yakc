module YAKC
  module Translator
    class Base
      class << self
        def translate( message )
          handle( message )
        rescue
          YAKC.logger.error e
          nil
        end
      end
    end
  end
end