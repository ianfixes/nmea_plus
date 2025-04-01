require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VCD - Current at Selected Depth
      # Limited utility, no recommended replacement
      class VCD < NMEAPlus::Message::NMEA::NMEAMessage
        # Depth, feet
        field_reader :depth_feet, 1, :_float

        # Depth, meters
        field_reader :depth_meters, 3, :_float

        # Current, knots
        field_reader :water_current_speed_knots, 5, :_float

        # Current, meters/second
        field_reader :water_current_speed_ms, 7, :_float
      end
    end
  end
end
