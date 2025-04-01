require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TGA - TRANSIT Satellite Antenna & Geoidal Heights
      # TRANSIT system is not operational, no recommended replacement.
      class TGA < NMEAPlus::Message::NMEA::NMEAMessage
        # Antenna height, meters
        field_reader :antenna_height_meters, 1, :_float

        # Geoidal height, meters
        field_reader :geoidal_height_meters, 3, :_float

        # Antenna geoidal height, meters
        field_reader :antenna_geoidal_height_meters, 5, :_float
      end
    end
  end
end
