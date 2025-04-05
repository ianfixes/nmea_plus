require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SSF - Position Correction Offset
      #
      # Amount of offset, and direction of offset, applied to measured position Lat/Lon to produce a displayed position Lat/Lon.
      # Limited utility, no recommended replacement
      class SSF < NMEAPlus::Message::NMEA::NMEAMessage

        # Latitude offset, minutes N/S
        # @!parse attr_reader :latitude_offset_minutes
        # @return [Float]
        def latitude_offset_minutes
          self.class.nsew_signed_float(@fields[1], @fields[2])
        end

        # Longitude offset, minutes E/W
        # @!parse attr_reader :longitude_offset_minutes
        # @return [Float]
        def longitude_offset_minutes
          self.class.nsew_signed_float(@fields[3], @fields[4])
        end

      end
    end
  end
end
