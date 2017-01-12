require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GDF - Dead Reckoning Positions
      class GDF < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
