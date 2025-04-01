require "nmea_plus/message/nmea/mmb"

module NMEAPlus
  module Message
    module NMEA
      # MDA - Meteorological Composite
      #
      # Barometric pressure, air and water temperature, humidity, dew point and wind speed and direction relative to the surface
      # of the earth.
      # The use of $--MTW, $--MWV and $--XDR is recommended.
      # @see MTW
      # @see MWV
      # @see XDR
      class MDA < NMEAPlus::Message::NMEA::MMB
        # Air temperature, degrees C
        field_reader :air_temperature_celsius, 5, :_float

        # Water temperature, degrees C
        field_reader :water_temperature_celsius, 7, :_float

        # Relative humidity, percent
        field_reader :relative_humidity_percent, 9, :_float

        # Absolute humidity, percent
        field_reader :absolute_humidity_percent, 10, :_float

        # Dew point, degrees C
        field_reader :dew_point_celsius, 11, :_float

        # Wind direction, degrees True
        field_reader :wind_true_direction_degrees, 13, :_float

        # Wind direction, degrees Magnetic
        field_reader :wind_magnetic_direction_degrees, 15, :_float

        # Wind speed, knots
        field_reader :wind_speed_knots, 17, :_float

        # Wind speed, meters/second
        field_reader :wind_speed_ms, 19, :_float
      end
    end
  end
end
