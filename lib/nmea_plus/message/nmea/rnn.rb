require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # RNN - Routes
      class RNN < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :route_number, 1, :_integer

        # Waypoint numbers
        # @!parse attr_reader :waypoints
        # @return [Array<Integer>]
        def waypoints
          @fields[2..-1].map(&:to_i)
        end
      end
    end
  end
end
