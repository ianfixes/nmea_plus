require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TTM - Tracked Target Message
      class TTM < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :target_number, 1, :_integer
        field_reader :target_distance, 2, :_float
        field_reader :target_bearing_from_ownship, 3, :_float
        field_reader :target_bearing_units, 4, :_string
        field_reader :target_speed, 5, :_float
        field_reader :target_course, 6, :_float
        field_reader :target_course_units, 7, :_string
        field_reader :closest_approach_point_distance, 8, :_float
        field_reader :closest_approach_point_time, 9, :_float
        field_reader :target_name, 11, :_string
        field_reader :target_status, 12, :_string
        field_reader :reference_target, 13, :_string
      end
    end
  end
end
