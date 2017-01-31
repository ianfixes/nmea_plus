require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SPS - Loran-C Predicted Signal Strength
      class SPS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :signal_strength_db, 1, :_float
      end
    end
  end
end
