require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GOP - Omega Determined Positions
      class GOP < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
