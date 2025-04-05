require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # XTR - Cross Track Error - Dead Reckoning
      class XTR < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :cross_track_error, 1, :_float
        field_reader :direction_to_steer, 2, :_string
      end
    end
  end
end
