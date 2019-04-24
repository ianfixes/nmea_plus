require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # TEP - TRANSIT Satellite Predicted Elevation
      # TRANSIT system is not operational, no recommended replacement.
      class TEP < NMEAPlus::Message::NMEA::NMEAMessage
        # Elevation, degrees
        field_reader :elevation_degrees, 1, :_float
      end
    end
  end
end
