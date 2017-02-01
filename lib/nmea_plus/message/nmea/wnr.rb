require_relative "wnc"

module NMEAPlus
  module Message
    module NMEA
      # WNR - Waypoint-to-Waypoint Distance, Rhumb Line
      class WNR < NMEAPlus::Message::NMEA::WNC; end
    end
  end
end
