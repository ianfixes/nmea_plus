require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SDB - Loran-C Signal Strength
      class SDB < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :signal_strength_db, 1, :_float
      end
    end
  end
end
