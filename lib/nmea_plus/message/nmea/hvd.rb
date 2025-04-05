require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # HVD - Magnetic Variation, Automatic
      #
      # Magnetic variation, automatically derived (calculated or from a data base)
      #
      # The use of $--HDG is recommended.
      # @see HDG
      class HVD < NMEAPlus::Message::NMEA::NMEAMessage
        # Magnetic variation, degrees E/W
        # @!parse attr_reader :magnetic_variation_degrees
        # @return [Float]
        def magnetic_variation_degrees
          self.class.nsew_signed_float(@fields[1], @fields[2])
        end

      end
    end
  end
end
