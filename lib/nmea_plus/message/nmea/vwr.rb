require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VWR - Relative Wind Speed and Angle
      # Wind angle in relation to the vessel's heading and wind speed measured relative to the moving vessel.
      #
      # The use of $--MWV is recommended
      # @see MWV
      class VWR < NMEAPlus::Message::NMEA::NMEAMessage
        # Measured wind angle relative to the vessel, 0 to 180, left/right L/R of vessel heading
        field_reader :measured_wind_direction_degrees, 1, :_float

        # Left/right L/R of vessel heading
        field_reader :measured_wind_direction_bow, 2, :_string

        # Measured wind Speed, knots
        field_reader :speed_knots, 3, :_float

        # Wind speed, meters/second
        field_reader :speed_ms, 5, :_float

        # Wind speed, Km/Hr
        field_reader :speed_kmh, 7, :_float
      end
    end
  end
end
