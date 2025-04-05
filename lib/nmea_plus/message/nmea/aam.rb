require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # AAM - Waypoint Arrival Alarm
      class AAM < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :arrival_circle_entered?, 1, :_av_boolean
        field_reader :waypoint_passed?, 2, :_av_boolean
        field_reader :arrival_circle_radius, 3, :_float
        field_reader :arrival_circle_radius_units, 4, :_string
        field_reader :waypoint_id, 5, :_string
      end
    end
  end
end
