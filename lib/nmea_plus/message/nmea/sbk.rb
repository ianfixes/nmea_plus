require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SBK - Loran-C Blink Status
      class SBK < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :blink_flag?, 1, :_av_boolean
      end
    end
  end
end
