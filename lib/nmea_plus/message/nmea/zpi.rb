require "nmea_plus/message/nmea/zaa"

module NMEAPlus
  module Message
    module NMEA
      # ZPI - Arrival time at point-of-interest
      # The use of $--ZTG is recommended.
      # @see ZTG
      class ZPI < NMEAPlus::Message::NMEA::ZAA
        # Arrival time at waypoint
        field_reader :arrival_time, 2, :_utctime_hms
      end
    end
  end
end
