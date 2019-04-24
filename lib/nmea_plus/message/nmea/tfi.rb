require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # TFI - Trawl Filling Indicator
      class TFI < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :catch_sensor1, 1, :_integer
        field_reader :catch_sensor2, 2, :_integer
        field_reader :catch_sensor3, 3, :_integer
      end
    end
  end
end
