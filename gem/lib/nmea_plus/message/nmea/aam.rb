
require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA

      class AAM < NMEAPlus::Message::NMEA::NMEAMessage
        def arrival_circle_entered?
          _av_boolean(@fields[1])
        end

        def waypoint_passed?
          _av_boolean(@fields[2])
        end

        def arrival_circle_radius
          _float(@fields[3])
        end

        def arrival_circle_radius_units
          _string(@fields[4])
        end

        def waypoint_id
          _string(@fields[5])
        end

      end
    end
  end
end
