require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class DTM < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :code, 1, :_string
        field_reader :subcode, 2, :_string

        # @!parse attr_reader :latitude_offset
        # @return [Float]
        def latitude_offset
          _nsew_signed_float(@fields[3], @fields[4])
        end

        # @!parse attr_reader :longitude_offset
        # @return [Float]
        def longitude_offset
          _nsew_signed_float(@fields[5], @fields[6])
        end

        field_reader :altitude_meters, 7, :_float
        field_reader :datum_name, 8, :_string

      end
    end
  end
end
