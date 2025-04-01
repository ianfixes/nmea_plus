require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MWH - Wave Height
      #
      # Limited utility, no recommended replacement.
      class MWH < NMEAPlus::Message::NMEA::NMEAMessage
        # Wave height, feet
        field_reader :wave_height_feet, 1, :_float

        # Wave height, meters
        field_reader :wave_height_meters, 3, :_float
      end
    end
  end
end
