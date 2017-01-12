require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GLP - Loran-C Determined Positions
      class GLP < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
