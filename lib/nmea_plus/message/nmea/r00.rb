require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # R00 - Waypoints in active route
      # Waypoint identifiers, listed in order with starting waypoint first, for route number "nn".
      # The use of $--RTE is recommended.
      # @see RTE
      class R00 < NMEAPlus::Message::NMEA::NMEAMessage
        # 14 field sequence of route waypoint IDs
        # @!parse attr_reader :waypoint_ids
        # @return [Array<String>]
        def waypoint_ids
          @fields[1..14]
        end
      end
    end
  end
end
