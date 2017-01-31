require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TGA - TRANSIT Satellite Antenna & Geoidal Heights
      class TGA < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :antenna_height_meters, 1, :_float
        field_reader :geoidal_height_meters, 3, :_float
        field_reader :antenna_geoidal_height_meters, 5, :_float
      end
    end
  end
end
