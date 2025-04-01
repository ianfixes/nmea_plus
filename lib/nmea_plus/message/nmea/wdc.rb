require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # WDC - Distance to Waypoint
      #
      # Distance from present position to the specified waypoint.
      # The use of $--BWC is recommended.
      # @see BWC
      class WDC < NMEAPlus::Message::NMEA::NMEAMessage
        # Distance, nautical miles
        field_reader :distance_nautical_miles, 1, :_float

        # Waypoint identifier
        field_reader :waypoint_id, 3, :_string
      end
    end
  end
end
