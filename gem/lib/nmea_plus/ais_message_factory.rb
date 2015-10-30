
require_relative "message_factory"

module NMEAPlus
  class AISMessageFactory < MessageFactory
    def self.output_class_prefix
      "AIS"
    end
  end

end
