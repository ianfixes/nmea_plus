require_relative "wdc"

module NMEAPlus
  module Message
    module NMEA
      # WDR - Waypoint Distance, Rhumb Line
      class WDR < NMEAPlus::Message::NMEA::WDC; end
    end
  end
end
