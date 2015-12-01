require_relative "base_nmea"
require_relative "bod"

module NMEAPlus
  module Message
    module NMEA
      class BWW < NMEAPlus::Message::NMEA::BOD
      end
    end
  end
end
