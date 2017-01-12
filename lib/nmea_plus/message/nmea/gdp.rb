require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GDP - Dead Reckoning Positions
      class GDP < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
