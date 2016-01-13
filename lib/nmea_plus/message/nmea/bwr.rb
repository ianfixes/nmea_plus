require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # BWR - Bearing and Distance to Waypoint - Rhumb Line
      class BWR < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :utc_time, 1, :_utctime_hms

        # @!parse attr_reader :waypoint_latitude
        # @return [Float]
        def waypoint_latitude
          self.class.degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        # @!parse attr_reader :waypoint_longitude
        # @return [Float]
        def waypoint_longitude
          self.class.degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        field_reader :bearing_true, 6, :_float
        field_reader :bearing_magnetic, 8, :_float
        field_reader :nautical_miles, 10, :_float
        field_reader :waypoint_id, 12, :_string

      end
    end
  end
end
