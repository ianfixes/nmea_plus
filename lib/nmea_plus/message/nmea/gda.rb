require_relative "gxa"

module NMEAPlus
  module Message
    module NMEA
      # GDA - Dead Reckoning Positions
      # Same fields as GXA
      class GDA < NMEAPlus::Message::NMEA::GXA
      end
    end
  end
end
