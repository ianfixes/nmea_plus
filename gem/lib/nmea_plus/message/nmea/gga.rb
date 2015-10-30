
require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA

      class GGA < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :fix_time, 1, :_utctime_hms

        def latitude
          _degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        def longitude
          _degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        field_reader :fix_quality, 6, :_integer
        field_reader :satellites, 7, :_integer
        field_reader :horizontal_dilution, 8, :_float
        field_reader :altitude, 9, :_float
        field_reader :altitude_units, 10, :_string
        field_reader :geoid_height, 11, :_float
        field_reader :geoid_height_units, 12, :_string
        field_reader :seconds_since_last_update, 13, :_float
        field_reader :dgps_station_id, 14, :_string
      end

    end
  end
end
