require_relative "bwr"

module NMEAPlus
  module Message
    module NMEA
      # BPI - Bearing & Distance to Point of Interest
      # Same fields as BWR
      #
      # Time (UTC) and distance & bearing to, and location of, a specified waypoint from present position:
      # BPI: Calculated along a great circle path from a measured present position. Redundant with
      # BWC, the use of $--BWC is recommended.
      # @see BWC
      class BPI < NMEAPlus::Message::NMEA::BWR
      end
    end
  end
end
