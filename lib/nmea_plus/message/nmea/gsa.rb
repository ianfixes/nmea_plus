require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # GSA - GPS DOP and active satellites
      class GSA < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :selection_mode, 1, :_string
        field_reader :mode, 2, :_integer
        field_reader :satellite1, 3, :_integer
        field_reader :satellite2, 4, :_integer
        field_reader :satellite3, 5, :_integer
        field_reader :satellite4, 6, :_integer
        field_reader :satellite5, 7, :_integer
        field_reader :satellite6, 8, :_integer
        field_reader :satellite7, 9, :_integer
        field_reader :satellite8, 10, :_integer
        field_reader :satellite9, 11, :_integer
        field_reader :satellite10, 12, :_integer
        field_reader :satellite11, 13, :_integer
        field_reader :satellite12, 14, :_integer
        field_reader :pdop, 15, :_string
        field_reader :hdop, 16, :_string
        field_reader :vdop, 17, :_string
      end
    end
  end
end
