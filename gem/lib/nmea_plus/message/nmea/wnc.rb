require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class WNC < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :distance_nautical_miles, 1, :_float
        field_reader :distance_kilometers, 3, :_float
        field_reader :waypoint_to, 5, :_string
        field_reader :waypoint_from, 6, :_string
      end
    end
  end
end
