require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # TPR - Trawl Position Relative Vessel
      class TPR < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :range_meters, 1, :_float
        field_reader :bearing_degrees, 3, :_float
        field_reader :depth_meters, 5, :_float
      end
    end
  end
end
