require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # WNC - Distance - Waypoint to Waypoint
      class WNC < NMEAPlus::Message::NMEA::NMEAMessage
        # Distance, nautical miles
        field_reader :distance_nautical_miles, 1, :_float

        # Distance, kilometers
        field_reader :distance_kilometers, 3, :_float

        # TO waypoint ID
        field_reader :waypoint_to, 5, :_string

        # FROM waypoint ID
        field_reader :waypoint_from, 6, :_string
      end
    end
  end
end
