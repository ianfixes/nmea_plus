
require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA

      class GPAAM < NMEAPlus::Message::NMEA::NMEAMessage
        def arrival_circle_entered?
          _aam_boolean(@fields[1])
        end

        def waypoint_passed?
          _aam_boolean(@fields[2])
        end

        def arrival_circle_radius
          _float(@fields[3])
        end

        def arrival_circle_radius_units
          _str(@fields[4])
        end

        def waypoint_id
          _str(@fields[5])
        end

        def _aam_boolean data
          case data
          when 'A'; return true
          when 'V'; return false
          end
          nil
        end
      end
    end
  end
end
