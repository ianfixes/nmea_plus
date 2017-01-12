require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GOF - Omega Determined Positions
      class GOF < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
