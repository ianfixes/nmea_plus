require "nmea_plus/message/nmea/bwr"

module NMEAPlus
  module Message
    module NMEA
      # BER - Bearing & Distance to Waypoint, Dead Reckoning, Rhumb Line
      # Same fields as BWR
      #
      # Time (UTC) and distance & bearing to, and location of, a specified waypoint from present position:
      # Calculated along the rhumb line from a dead reckoned present position. The use of
      # $--BEC using great circle calculations is recommended.
      # @see BEC
      class BER < NMEAPlus::Message::NMEA::BWR
      end
    end
  end
end
