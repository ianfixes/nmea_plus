require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # GSV - Satellites in view
      class GSV < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :total_messages, 1, :_integer
        field_reader :message_number, 2, :_integer
        field_reader :satellites, 3, :_integer
        field_reader :satellite1_prn, 4, :_integer
        field_reader :satellite1_elevation_degrees, 5, :_float
        field_reader :satellite1_azimuth_degrees, 6, :_float
        field_reader :satellite1_snr, 7, :_float
        field_reader :satellite2_prn, 8, :_integer
        field_reader :satellite2_elevation_degrees, 9, :_float
        field_reader :satellite2_azimuth_degrees, 10, :_float
        field_reader :satellite2_snr, 11, :_float
        field_reader :satellite3_prn, 12, :_integer
        field_reader :satellite3_elevation_degrees, 13, :_float
        field_reader :satellite3_azimuth_degrees, 14, :_float
        field_reader :satellite3_snr, 15, :_float
        field_reader :satellite4_prn, 16, :_integer
        field_reader :satellite4_elevation_degrees, 17, :_float
        field_reader :satellite4_azimuth_degrees, 18, :_float
        field_reader :satellite4_snr, 19, :_float
      end
    end
  end
end
