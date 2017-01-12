require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GLF - Loran-C Determined Positions
      class GLF < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
