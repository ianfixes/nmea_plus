require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # APA - Autopilot Sentence "A"
      class APA < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :no_general_warning?, 1, :_av_boolean
        field_reader :no_cyclelock_warning?, 2, :_av_boolean
        field_reader :cross_track_error, 3, :_float
        field_reader :direction_to_steer, 4, :_string
        field_reader :cross_track_units, 5, :_string
        field_reader :arrival_circle_entered?, 6, :_av_boolean
        field_reader :perpendicular_passed?, 7, :_av_boolean
        field_reader :bearing_origin_to_destination, 8, :_float
        field_reader :compass_type, 9, :_string
        field_reader :destination_waypoint_id, 10, :_string
      end
    end
  end
end
