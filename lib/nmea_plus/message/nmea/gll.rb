require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class GLL < NMEAPlus::Message::NMEA::NMEAMessage
        def latitude
          _degrees_minutes_to_decimal(@fields[1], @fields[2])
        end

        def longitude
          _degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        field_reader :fix_time, 5, :_utctime_hms
        field_reader :valid?, 6, :_av_boolean
        field_reader :faa_mode, 7, :_string
      end
    end
  end
end
