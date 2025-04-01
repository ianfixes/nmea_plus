require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # BWR - Bearing and Distance to Waypoint - Rhumb Line
      class BWR < NMEAPlus::Message::NMEA::NMEAMessage
        # UTC of observation
        field_reader :utc_time, 1, :_utctime_hms

        # Waypoint latitude, N/S
        # @!parse attr_reader :waypoint_latitude
        # @return [Float]
        def waypoint_latitude
          self.class.degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        # Waypoint longitude, E/W
        # @!parse attr_reader :waypoint_longitude
        # @return [Float]
        def waypoint_longitude
          self.class.degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        # Bearing, degrees True
        field_reader :bearing_true, 6, :_float

        # Bearing, degrees Magnetic
        field_reader :bearing_magnetic, 8, :_float

        # Distance, nautical miles
        field_reader :nautical_miles, 10, :_float

        # Waypoint ID
        field_reader :waypoint_id, 12, :_string

      end
    end
  end
end
