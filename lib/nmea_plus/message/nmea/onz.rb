require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # ONZ- Omega Zone Number
      #
      # OMEGA system is not operational, no recommended replacement.
      class ONZ < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :station_identifier, 1, :_string
      end
    end
  end
end
