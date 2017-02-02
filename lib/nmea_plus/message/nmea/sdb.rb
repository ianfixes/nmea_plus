require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SDB - Loran-C Signal Strength
      # Limited utility, no recommended replacement.
      class SDB < NMEAPlus::Message::NMEA::NMEAMessage
        # Signal strength, dB
        field_reader :signal_strength_db, 1, :_float
      end
    end
  end
end
