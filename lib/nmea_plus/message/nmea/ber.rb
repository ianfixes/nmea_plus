require_relative "bwr"

module NMEAPlus
  module Message
    module NMEA
      # BER - Bearing & Distance to Waypoint, Dead Reckoning, Rhumb Line
      # Same fields as BWR
      class BER < NMEAPlus::Message::NMEA::BWR
      end
    end
  end
end
