require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TDS - Trawl Door Spread Distance
      class TDS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :door_spread_distance_meters, 1, :_float
      end
    end
  end
end
