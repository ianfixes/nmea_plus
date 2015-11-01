require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class RMC < NMEAPlus::Message::NMEA::NMEAMessage

        def utc_time
          _utc_date_time(@fields[9], @fields[1])
        end

        field_reader :active?, 2, :_av_boolean

        def latitude
          _degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        def longitude
          _degrees_minutes_to_decimal(@fields[5], @fields[6])
        end

        field_reader :speed_over_ground_knots, 7, :_float
        field_reader :track_made_good_degrees_true, 8, :_float

        def magnetic_variation_degrees
          _nsew_signed_float(@fields[10], @fields[11])
        end

        field_reader :faa_mode, 12, :_string
      end
    end
  end
end
