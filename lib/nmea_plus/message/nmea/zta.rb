require_relative "zaa"

module NMEAPlus
  module Message
    module NMEA
      # ZTA - Estimated time of arrival at waypoint.
      class ZTA < NMEAPlus::Message::NMEA::ZAA
        field_reader :estimated_arrival_time, 2, :_utctime_hms
      end
    end
  end
end
