require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # ITS - Trawl Door Spread 2 Distance
      class ITS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :second_spread_distance_meters, 1, :_float
      end
    end
  end
end
