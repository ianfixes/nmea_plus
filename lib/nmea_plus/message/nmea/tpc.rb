require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TPC - Trawl Position Cartesian Coordinates
      class TPC < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :distance_abeam_meters, 1, :_float
        field_reader :distance_abaft_meters, 3, :_float
        field_reader :depth_meters, 5, :_float
      end
    end
  end
end
