require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # WDC - Distance to Waypoint
      class WDC < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :distance_nautical_miles, 1, :_float
        field_reader :waypoint_id, 3, :_string
      end
    end
  end
end
