require "nmea_plus/message/nmea/wdc"

module NMEAPlus
  module Message
    module NMEA
      # WDR - Waypoint Distance, Rhumb Line
      # The use of $--WDC using great circle calculations is recommended.
      # @see WDC
      class WDR < NMEAPlus::Message::NMEA::WDC; end
    end
  end
end
