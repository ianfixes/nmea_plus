require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GOA - OMEGA Positions
      # Same fields as GDA
      class GOA < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
