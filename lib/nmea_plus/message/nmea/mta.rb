require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MTA - Air Temperature
      class MTA < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :temperature_celsius, 1, :_float
      end
    end
  end
end
