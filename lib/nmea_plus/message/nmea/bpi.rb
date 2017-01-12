require_relative "bwr"

module NMEAPlus
  module Message
    module NMEA
      # BPI - Bearing & Distance to Point of Interest
      # Same fields as BWR
      class BPI < NMEAPlus::Message::NMEA::BWR
      end
    end
  end
end
