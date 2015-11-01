require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class HDG < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :magnetic_heading_degrees, 1, :_float

        def magnetic_deviation_degrees
          _nsew_signed_float(@fields[2], @fields[3])
        end

        def magnetic_variation_degrees
          _nsew_signed_float(@fields[4], @fields[5])
        end

      end
    end
  end
end
