require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # ZTG - UTC & Time to Destination Waypoint
      class ZTG < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :utc_time, 1, :_utctime_hms
        # field_reader :remaining_time, 2, :_interval_hms
        field_reader :destination_waypoint_id, 3, :_string
      end
    end
  end
end
