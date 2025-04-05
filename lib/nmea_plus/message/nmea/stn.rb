require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # STN - Multiple Data ID
      class STN < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :talker_id, 1, :_float
      end
    end
  end
end
