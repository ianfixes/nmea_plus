require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MMB - Barometer
      #
      # The use of $--XDR is recommended.
      # @see XDR
      class MMB < NMEAPlus::Message::NMEA::NMEAMessage
        # Barometric pressure, inches of mercury
        field_reader :barometric_pressure_inches, 1, :_float

        # Barometric pressure, bars
        field_reader :barometric_pressure_bars, 3, :_float
      end
    end
  end
end
