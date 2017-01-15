require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MWH - Wave Height
      class MWH < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :wave_height_feet, 1, :_float
        field_reader :wave_height_meters, 3, :_float
      end
    end
  end
end
