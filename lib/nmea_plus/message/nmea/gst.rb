require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # GST - GPS Pseudorange Noise Statistics
      class GST < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :gga_fix_time, 1, :_utctime_hms
        field_reader :total_rms_standard_deviation, 2, :_float
        field_reader :standard_deviation_semimajor_meters, 3, :_float
        field_reader :standard_deviation_semiminor_meters, 4, :_float
        field_reader :semimajor_error_ellipse_orientation_degrees, 5, :_float
        field_reader :standard_deviation_latitude_meters, 6, :_float
        field_reader :standard_deviation_longitude_meters, 7, :_float
        field_reader :standard_deviation_altitude_meters, 8, :_float
      end
    end
  end
end
