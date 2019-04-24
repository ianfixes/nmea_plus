require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # TPT - Trawl Position True
      class TPT < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :range_meters, 1, :_float
        field_reader :bearing_true_degrees, 3, :_float
        field_reader :depth_meters, 5, :_float
      end
    end
  end
end
