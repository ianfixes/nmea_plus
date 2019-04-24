require 'nmea_plus/message/nmea/base_nmea'
require 'nmea_plus/message/nmea/bwr'

module NMEAPlus
  module Message
    module NMEA
      # BWC - Bearing & Distance to Waypoint - Great Circle
      class BWC < NMEAPlus::Message::NMEA::BWR
        field_reader :faa_mode, 13, :_string
      end
    end
  end
end
