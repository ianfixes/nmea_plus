require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TEP - TRANSIT Satellite Predicted Elevation
      class TEP < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :elevation_degrees, 1, :_float
      end
    end
  end
end
