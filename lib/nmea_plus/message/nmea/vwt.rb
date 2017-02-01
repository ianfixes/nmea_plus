require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VWT - True Wind Speed and Angle
      class VWT < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :calculated_wind_direction_degrees, 1, :_float
        field_reader :calculated_wind_direction_bow, 2, :_string
        field_reader :speed_knots, 3, :_float
        field_reader :speed_ms, 5, :_float
        field_reader :speed_kmh, 7, :_float
      end
    end
  end
end
