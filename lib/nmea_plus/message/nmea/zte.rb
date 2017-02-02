require_relative "zaa"

module NMEAPlus
  module Message
    module NMEA
      # ZTE - Estimated time to event
      # The use of $--ZTG is recommended.
      # @see ZTG
      class ZTE < NMEAPlus::Message::NMEA::ZAA
        # Estimated time-to-go to waypoint
        field_reader :estimated_remaining_time, 2, :_interval_hms
      end
    end
  end
end
