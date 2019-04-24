require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # SCY - Loran-C Cycle Lock Status
      # Loran-C warning flags for Cycle Lock indicating that one or more Loran-C stations being
      # used to produce Lat/Lon and other navigation data are unreliable.
      # The use of $--GLC is recommended.
      # @see GLC
      class SCY < NMEAPlus::Message::NMEA::NMEAMessage
        # Warning Flag
        field_reader :cycle_lock_flag?, 1, :_av_boolean
      end
    end
  end
end
