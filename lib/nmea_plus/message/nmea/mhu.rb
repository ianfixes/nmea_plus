require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MHU - Humidity
      #
      # The use of $--XDR is recommended.
      # @see XDR
      class MHU < NMEAPlus::Message::NMEA::NMEAMessage
        # Relative humidity, percent
        field_reader :relative_humidity_percent, 1, :_float

        # Absolute humidity, percent
        field_reader :absolute_humidity_percent, 2, :_float

        # Dew point, degrees C
        field_reader :dew_point_celsius, 3, :_float
      end
    end
  end
end
