require_relative "base_nmea"
require_relative "dbk"

module NMEAPlus
  module Message
    module NMEA
      class DBS < NMEAPlus::Message::NMEA::DBK
      end
    end
  end
end
