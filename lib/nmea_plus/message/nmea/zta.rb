require 'nmea_plus/message/nmea/zaa'

module NMEAPlus
  module Message
    module NMEA
      # ZTA - Estimated time of arrival at waypoint.
      # The use of $--ZTG is recommended.
      # @see ZTG
      class ZTA < NMEAPlus::Message::NMEA::ZAA
        # Estimated arrival time at waypoint
        field_reader :estimated_arrival_time, 2, :_utctime_hms
      end
    end
  end
end
