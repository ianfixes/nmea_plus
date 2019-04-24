require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # VDR - Set and Drift
      class VDR < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :degrees_true, 1, :_float
        field_reader :degrees_magnetic, 3, :_float
        field_reader :water_current_speed_knots, 5, :_float
      end
    end
  end
end
