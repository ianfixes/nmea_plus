require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class GPALM < NMEAPlus::Message::NMEA::NMEAMessage
        def total_messages
          _integer(@fields[1])
        end

        def message_number
          _integer(@fields[2])
        end

        def satellite_prn
          _integer(@fields[3])
        end

        def gps_week
          _integer(@fields[4])
        end

        def sv_health
          _hex_to_integer(@fields[5])
        end

        def eccentricity
          _hex_to_integer(@fields[6])
        end

        def reference_time
          _hex_to_integer(@fields[7])
        end

        def inclination_angle
          _hex_to_integer(@fields[8])
        end

        def ascension_rate
          _hex_to_integer(@fields[9])
        end

        def semimajor_axis_root
          _hex_to_integer(@fields[10])
        end

        def perigee_argument
          _hex_to_integer(@fields[11])
        end

        def ascension_node_longitude
          _hex_to_integer(@fields[12])
        end

        def mean_anomaly
          _hex_to_integer(@fields[13])
        end

        def f0_clock
          _hex_to_integer(@fields[14])
        end

        def f1_clock
          _hex_to_integer(@fields[15])
        end

      end
    end
  end
end
