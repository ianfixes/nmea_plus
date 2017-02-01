require_relative "vta"

module NMEAPlus
  module Message
    module NMEA
      # VTI - Intended Track
      class VTI < NMEAPlus::Message::NMEA::VTA; end
    end
  end
end
