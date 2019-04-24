require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # SBK - Loran-C Blink Status
      # Loran-C warning flag for Blink indicating that one or more Loran-C stations being
      # used to produce Lat/Lon and other navigation data are unreliable.
      # The use of $--GLC is recommended.
      # @see GLC
      class SBK < NMEAPlus::Message::NMEA::NMEAMessage
        # Warning Flag
        field_reader :blink_flag?, 1, :_av_boolean
      end
    end
  end
end
