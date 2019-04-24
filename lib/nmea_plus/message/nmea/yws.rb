require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # YWS - Water Profile
      # Limited utility, no recommended replacement
      class YWS < NMEAPlus::Message::NMEA::NMEAMessage
        # Salinity, parts/thousand
        field_reader :salinity_ppt, 1, :_float

        # Chlorinity, parts/thousand
        field_reader :chlorinity_ppt, 2, :_float

        # Temperature at depth, degrees C
        field_reader :temperature_celsius, 3, :_float

        # Depth, feet
        field_reader :depth_feet, 5, :_float

        # Depth, meters
        field_reader :depth_meters, 7, :_float
      end
    end
  end
end
