require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class ITS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :second_spread_distance_meters, 1, :_float
      end
    end
  end
end
