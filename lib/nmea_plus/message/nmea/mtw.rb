require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MTW - Mean Temperature of Water
      class MTW < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :degrees, 1, :_float
        field_reader :units, 2, :_string
      end
    end
  end
end
