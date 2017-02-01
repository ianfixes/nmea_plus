require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # YWS - Water Profile
      class YWS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :salinity_ppt, 1, :_float
        field_reader :chlorinity_ppt, 2, :_float
        field_reader :temperature_celsius, 3, :_float
        field_reader :depth_feet, 5, :_float
        field_reader :depth_meters, 7, :_float
      end
    end
  end
end
