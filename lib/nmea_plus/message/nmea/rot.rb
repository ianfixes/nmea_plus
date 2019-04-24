require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # ROT - Rate Of Turn
      class ROT < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :rate_of_turn_starboard_degrees_per_minute, 1, :_float
        field_reader :valid?, 2, :_av_boolean
      end
    end
  end
end
