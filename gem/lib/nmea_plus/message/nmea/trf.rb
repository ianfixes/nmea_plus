require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class TRF < NMEAPlus::Message::NMEA::NMEAMessage
        def utc_time
          _utc_date_time(@fields[2], @fields[1])
        end

        def latitude
          _degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        def longitude
          _degrees_minutes_to_decimal(@fields[5], @fields[6])
        end

        field_reader :elevation_angle, 7, :_float
        field_reader :iterations, 8, :_integer
        field_reader :doppler_intervals, 9, :_integer
        field_reader :update_distance_nautical_miles, 10, :_float
        field_reader :satellite, 11, :_integer
        field_reader :valid?, 12, :_av_boolean
      end
    end
  end
end
