require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VLW - Distance Traveled through Water
      class VLW < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :total_distance_nautical_miles, 1, :_float
        field_reader :distance_since_reset_nautical_miles, 3, :_float
      end
    end
  end
end
