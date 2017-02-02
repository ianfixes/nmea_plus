require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # R00 - Waypoints in active route
      class R00 < NMEAPlus::Message::NMEA::NMEAMessage
        # @!parse attr_reader :waypoint_ids
        # @return [Array<String>]
        def waypoint_ids
          @fields[1..14]
        end
      end
    end
  end
end
