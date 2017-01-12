require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GLA - Loran-C Positions
      # Same fields as GDA
      class GLA < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
