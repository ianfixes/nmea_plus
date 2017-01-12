require_relative "gda"

module NMEAPlus
  module Message
    module NMEA
      # GXA - TRANSIT Position - Latitude/Longitude
      class GXA < NMEAPlus::Message::NMEA::GDA
        field_reader :satellite, 7, :_integer
      end
    end
  end
end
