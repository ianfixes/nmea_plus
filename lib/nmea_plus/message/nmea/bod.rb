require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # BOD - Bearing - Waypoint to Waypoint
      class BOD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :bearing_true, 1, :_float
        field_reader :bearing_magnetic, 3, :_float
        field_reader :waypoint_to, 5, :_string
        field_reader :waypoint_from, 6, :_string
      end
    end
  end
end
