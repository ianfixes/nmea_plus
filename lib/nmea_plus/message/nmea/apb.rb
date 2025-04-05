require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # APB - Autopilot Sentence "B"
      class APB < NMEAPlus::Message::NMEA::APA
        field_reader :bearing_position_to_destination, 11, :_float
        field_reader :bearing_position_to_destination_compass_type, 12, :_string
        field_reader :heading_to_waypoint, 13, :_float
        field_reader :heading_to_waypoint_compass_type, 14, :_string
      end
    end
  end
end
