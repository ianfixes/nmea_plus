require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class STN < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :talker_id, 1, :_float
      end
    end
  end
end
