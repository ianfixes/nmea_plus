require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # GBS - GPS Satellite Fault Detection
      class GBS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :fix_time, 1, :_utctime_hms
        field_reader :expected_error_latitude_meters, 2, :_float
        field_reader :expected_error_longitude_meters, 3, :_float
        field_reader :expected_error_altitude_meters, 4, :_float
        field_reader :failed_satelite_prn, 5, :_integer
        field_reader :missed_detection_probability, 6, :_float
        field_reader :failed_satellite_bias_meters, 7, :_float
        field_reader :bias_standard_deviation, 8, :_float
      end
    end
  end
end
