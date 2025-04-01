require "nmea_plus/message/nmea/zaa"

module NMEAPlus
  module Message
    module NMEA
      # ZFI - Elapsed time from point-of-interest
      # The use of $--ZFO is recommended.
      # @see ZFO
      class ZFI < NMEAPlus::Message::NMEA::ZAA
        # Elapsed time from waypoint
        field_reader :elapsed_time, 2, :_interval_hms
      end
    end
  end
end
