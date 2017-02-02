require_relative "zpi"

module NMEAPlus
  module Message
    module NMEA
      # ZWP - Arrival time at waypoint
      class ZWP < NMEAPlus::Message::NMEA::ZPI; end
    end
  end
end
