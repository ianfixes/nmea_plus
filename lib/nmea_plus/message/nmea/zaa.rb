require "nmea_plus/message/nmea/zzu"

module NMEAPlus
  module Message
    module NMEA
      # ZAA - Time, Elapsed/Estimated
      # Base class for a series of deprecated $--Z-- messages
      class ZAA < NMEAPlus::Message::NMEA::ZZU
        # Waypoint ID
        field_reader :waypoint_id, 3, :_string
      end
    end
  end
end
