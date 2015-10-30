
require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA

      class GGA < NMEAPlus::Message::NMEA::NMEAMessage
        def fix_time
          _utctime_hms(@fields[1])
        end

        def latitude
          _degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        def longitude
          _degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        def fix_quality
          _integer(@fields[6])
        end

        def satellites
          _integer(@fields[7])
        end

        def horizontal_dilution
          _float(@fields[8])
        end

        def altitude
          _float(@fields[9])
        end

        def altitude_units
          _string(@fields[10])
        end

        def geoid_height
          _float(@fields[11])
        end

        def geoid_height_units
          _string(@fields[12])
        end

        def seconds_since_last_update
          _float(@fields[13])
        end

        def dgps_station_id
          _string(@fields[14])
        end
      end

    end
  end
end
