require_relative "gxa"

module NMEAPlus
  module Message
    module NMEA
      # GLA - Loran-C Positions
      # Same fields as GXA
      class GLA < NMEAPlus::Message::NMEA::GXA
      end
    end
  end
end
