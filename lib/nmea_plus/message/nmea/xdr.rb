require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # XDR - Transducer Measurement
      class XDR < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :type, 1, :_string
        field_reader :measurement, 2, :_float
        field_reader :measurement_unit, 3, :_string
        field_reader :name, 4, :_string
      end
    end
  end
end
