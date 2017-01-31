require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VCD - Current at Selected Depth
      class VCD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :depth_feet, 1, :_float
        field_reader :depth_meters, 3, :_float
        field_reader :water_current_speed_knots, 5, :_float
        field_reader :water_current_speed_ms, 7, :_float
      end
    end
  end
end
