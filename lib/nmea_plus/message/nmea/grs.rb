require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # GRS - GPS Range Residuals
      class GRS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :gga_fix_time, 1, :_utctime_hms
        field_reader :gga_includes_residuals?, 2, :_10_boolean
        # These field names come from the NMEA spec, which we mirror
        # rubocop:disable Naming/VariableNumber
        field_reader :residual_satellite_1, 3, :_float
        field_reader :residual_satellite_2, 4, :_float
        field_reader :residual_satellite_3, 5, :_float
        field_reader :residual_satellite_4, 6, :_float
        field_reader :residual_satellite_5, 7, :_float
        field_reader :residual_satellite_6, 8, :_float
        field_reader :residual_satellite_7, 9, :_float
        field_reader :residual_satellite_8, 10, :_float
        field_reader :residual_satellite_9, 11, :_float
        field_reader :residual_satellite_10, 12, :_float
        field_reader :residual_satellite_11, 13, :_float
        field_reader :residual_satellite_12, 14, :_float
        # rubocop:enable Naming/VariableNumber
      end
    end
  end
end
