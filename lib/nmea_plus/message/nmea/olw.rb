require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # OLW - Omega Lane Width
      class OLW < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :width_nautical_miles, 1, :_float
        field_reader :width_meters, 3, :_float
      end
    end
  end
end
