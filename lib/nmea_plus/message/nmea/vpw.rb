require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VPW - Speed - Measured Parallel to Wind
      class VPW < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :parallel_wind_speed_knots, 1, :_float
        field_reader :parallel_wind_speed_ms, 3, :_float
      end
    end
  end
end
