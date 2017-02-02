require_relative "bwr"

module NMEAPlus
  module Message
    module NMEA
      # BEC - Bearing & Distance, Great Circle
      # Same fields as BWR
      class BEC < NMEAPlus::Message::NMEA::BWR
      end
    end
  end
end
