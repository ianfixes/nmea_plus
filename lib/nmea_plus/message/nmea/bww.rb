require 'nmea_plus/message/nmea/base_nmea'
require 'nmea_plus/message/nmea/bod'

module NMEAPlus
  module Message
    module NMEA
      # BWW - Bearing - Waypoint to Waypoint
      class BWW < NMEAPlus::Message::NMEA::BOD
      end
    end
  end
end
