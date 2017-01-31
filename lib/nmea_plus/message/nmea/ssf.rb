require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SSF - Position Correction Offset
      class SSF < NMEAPlus::Message::NMEA::NMEAMessage

        # @!parse attr_reader :latitude_offset_minutes
        # @return [Float]
        def latitude_offset_minutes
          self.class.nsew_signed_float(@fields[1], @fields[2])
        end

        # @!parse attr_reader :longitude_offset_minutes
        # @return [Float]
        def longitude_offset_minutes
          self.class.nsew_signed_float(@fields[3], @fields[4])
        end

      end
    end
  end
end
