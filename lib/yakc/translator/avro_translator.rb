module YAKC
  module Translator
    class AvroTranslator < Base
      class << self
        protected 

        def handle(message)
          data = StringIO.new(message.value)
          msg = Avro::DataFile::Reader.new(data, Avro::IO::DatumReader.new)
        end
      end
    end
  end
end