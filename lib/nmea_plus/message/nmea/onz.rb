require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # ONZ- Omega Zone Number
      class ONZ < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :station_identifier, 1, :_string
      end
    end
  end
end
