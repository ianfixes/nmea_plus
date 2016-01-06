require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # R00 - Waypoints in active route
      class R00 < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :waypoint_id, 1, :_string
      end
    end
  end
end
