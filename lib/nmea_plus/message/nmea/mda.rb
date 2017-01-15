require_relative "mmb"

module NMEAPlus
  module Message
    module NMEA
      # MDA - Meteorological Composite
      class MDA < NMEAPlus::Message::NMEA::MMB
        field_reader :air_temperature_celsius, 5, :_float
        field_reader :water_temperature_celsius, 7, :_float
        field_reader :relative_humidity_percent, 9, :_float
        field_reader :absolute_humidity_percent, 10, :_float
        field_reader :dew_point_celsius, 11, :_float
        field_reader :wind_true_direction_degrees, 13, :_float
        field_reader :wind_magnetic_direction_degrees, 15, :_float
        field_reader :wind_speed_knots, 17, :_float
        field_reader :wind_speed_ms, 19, :_float
      end
    end
  end
end
