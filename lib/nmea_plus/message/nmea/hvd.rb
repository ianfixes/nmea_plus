require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # HVD - Magnetic Variation, Automatic
      class HVD < NMEAPlus::Message::NMEA::NMEAMessage

        # @!parse attr_reader :magnetic_variation_degrees
        # @return [Float]
        def magnetic_variation_degrees
          self.class.nsew_signed_float(@fields[1], @fields[2])
        end

      end
    end
  end
end
