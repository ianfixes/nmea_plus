require 'nmea_plus/message/nmea/zte'

module NMEAPlus
  module Message
    module NMEA
      # ZTI - Estimated time to point-of-interest
      # The use of $--ZTG is recommended.
      # @see ZTG
      class ZTI < NMEAPlus::Message::NMEA::ZTE; end
    end
  end
end
