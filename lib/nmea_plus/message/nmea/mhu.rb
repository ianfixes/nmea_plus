require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MHU - Humidity
      class MHU < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :relative_humidity_percent, 1, :_float
        field_reader :absolute_humidity_percent, 2, :_float
        field_reader :dew_point_celsius, 3, :_float
      end
    end
  end
end
