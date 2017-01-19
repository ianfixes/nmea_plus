require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SGD - Position Accuracy Estimate
      class SGD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :accuracy_feet, 1, :_float
        field_reader :accuracy_nautical_miles, 3, :_float
      end
    end
  end
end
