require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MTA - Air Temperature
      #
      # The use of $--XDR is recommended.
      # @see XDR
      class MTA < NMEAPlus::Message::NMEA::NMEAMessage
        # Temperature, degrees C
        field_reader :temperature_celsius, 1, :_float
      end
    end
  end
end
