require_relative "zte"

module NMEAPlus
  module Message
    module NMEA
      # ZTI - Estimated time to point-of-interest
      class ZTI < NMEAPlus::Message::NMEA::ZTE; end
    end
  end
end
