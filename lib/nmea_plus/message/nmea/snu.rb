require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SNU - Loran-C SNR Status
      class SNU < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :warning_flag, 1, :_av_boolean
      end
    end
  end
end
