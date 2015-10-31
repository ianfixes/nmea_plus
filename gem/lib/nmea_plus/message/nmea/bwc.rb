require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class BWC  < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :utc_time, 1, :_utctime_hms

        def waypoint_latitude
          _degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        def waypoint_longitude
          _degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        field_reader :bearing_true, 6, :_float
        field_reader :bearing_magnetic, 8, :_float
        field_reader :nautical_miles, 10, :_float
        field_reader :waypoint_id, 12, :_string
        field_reader :faa_mode, 13, :_string

      end
    end
  end
end
