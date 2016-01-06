require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # GLL - Geographic Position - Latitude/Longitude
      class GLL < NMEAPlus::Message::NMEA::NMEAMessage

        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          _degrees_minutes_to_decimal(@fields[1], @fields[2])
        end

        # @!parse attr_reader :longitude
        # @return [Float]
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
