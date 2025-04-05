require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # ZFO - UTC & Time from origin Waypoint
      class ZFO < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :utc_time, 1, :_utctime_hms
        field_reader :elapsed_time, 2, :_interval_hms
        field_reader :origin_waypoint_id, 3, :_string
      end
    end
  end
end
