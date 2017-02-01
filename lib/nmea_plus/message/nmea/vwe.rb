require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VWE - Wind Track Efficiency
      class VWE < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :efficiency_percent, 1, :_float
      end
    end
  end
end
