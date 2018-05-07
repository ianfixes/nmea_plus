require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # RMB - Recommended Minimum Navigation Information
      class RMB < NMEAPlus::Message::NMEA::NMEAMessage

        field_reader :active?, 1, :_av_boolean
        field_reader :cross_track_error_nautical_miles, 2, :_float
        field_reader :direction_to_steer, 3, :_string
        field_reader :waypoint_to, 4, :_integer
        field_reader :waypoint_from, 5, :_integer

        # Waypoint latitude in degrees
        # @!parse attr_reader :waypoint_latitude
        # @return [Float]
        def waypoint_latitude
          self.class.degrees_minutes_to_decimal(@fields[6], @fields[7])
        end

        # Waypoint longitude in degrees
        # @!parse attr_reader :waypoint_longitude
        # @return [Float]
        def waypoint_longitude
          self.class.degrees_minutes_to_decimal(@fields[8], @fields[9])
        end

        field_reader :range_to_destination_nautical_miles, 10, :_float
        field_reader :bearing_to_destination_degrees_true, 11, :_float
        field_reader :destination_closing_velocity_knots, 12, :_float
        field_reader :arrival_circle_entered?, 13, :_av_boolean
        field_reader :faa_mode, 14, :_string
      end
    end
  end
end
