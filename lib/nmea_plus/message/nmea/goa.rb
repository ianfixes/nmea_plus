require_relative "gxa"

module NMEAPlus
  module Message
    module NMEA
      # GOA - OMEGA Positions
      # Same fields as GXA
      class GOA < NMEAPlus::Message::NMEA::GXA
      end
    end
  end
end
