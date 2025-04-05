require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # WFM - Route Following Mode
      class WFM < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :automatic_route_following, 1, :_av_boolean
      end
    end
  end
end
