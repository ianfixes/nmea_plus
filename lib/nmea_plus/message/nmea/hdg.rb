require "nmea_plus/message/nmea/hdm"

module NMEAPlus
  module Message
    module NMEA
      # HDG - Heading - Deviation & Variation
      class HDG < NMEAPlus::Message::NMEA::HDM

        # Magnetic deviation in degrees
        # @!parse attr_reader :magnetic_deviation_degrees
        # @return [Float]
        def magnetic_deviation_degrees
          self.class.nsew_signed_float(@fields[2], @fields[3])
        end

        # Magnetic variation in degrees
        # @!parse attr_reader :magnetic_variation_degrees
        # @return [Float]
        def magnetic_variation_degrees
          self.class.nsew_signed_float(@fields[4], @fields[5])
        end

      end
    end
  end
end
