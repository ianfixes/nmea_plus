require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class MWV < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :wind_angle, 1, :_float
        field_reader :wind_angle_reference, 2, :_string
        field_reader :wind_speed, 3, :_float
        field_reader :wind_speed_units, 4, :_string
        field_reader :valid?, 5, :_av_boolean
      end
    end
  end
end
