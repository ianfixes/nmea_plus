require_relative "wnc"

module NMEAPlus
  module Message
    module NMEA
      # WNR - Waypoint-to-Waypoint Distance, Rhumb Line
      # The use of $--WNC using great circle calculations is recommended.
      # @see WNC
      class WNR < NMEAPlus::Message::NMEA::WNC; end
    end
  end
end
