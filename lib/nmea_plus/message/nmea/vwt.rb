require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # VWT - True Wind Speed and Angle
      #
      # True wind angle in relation to the vessel's heading and true wind speed
      # referenced to the water. True wind is the vector sum of the Relative
      # (Apparent) wind vector and the vessel's velocity vector relative to the
      # water along the heading line of the vessel. It represents the wind at
      # the vessel if it were stationary relative to the water and heading in
      # the same direction.
      #
      # The use of $--MWV is recommended
      # @see MWV
      class VWT < NMEAPlus::Message::NMEA::NMEAMessage
        # Calculated wind angle relative to the vessel, 0 to 180, left/right L/R of vessel heading
        field_reader :calculated_wind_direction_degrees, 1, :_float

        # left/right L/R of vessel heading
        field_reader :calculated_wind_direction_bow, 2, :_string

        # Calculated wind Speed, knots
        field_reader :speed_knots, 3, :_float

        # Wind speed, meters/second
        field_reader :speed_ms, 5, :_float

        # Wind speed, Km/Hr
        field_reader :speed_kmh, 7, :_float
      end
    end
  end
end
