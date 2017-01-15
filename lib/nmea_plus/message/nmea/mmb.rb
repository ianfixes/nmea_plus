require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MMB - Barometer
      class MMB < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :barometric_pressure_inches, 1, :_float
        field_reader :barometric_pressure_bars, 3, :_float
      end
    end
  end
end
