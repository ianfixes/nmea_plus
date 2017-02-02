require_relative "zpi"

module NMEAPlus
  module Message
    module NMEA
      # ZWP - Arrival time at waypoint
      # The use of $--ZTG is recommended.
      # @see ZTG
      class ZWP < NMEAPlus::Message::NMEA::ZPI; end
    end
  end
end
