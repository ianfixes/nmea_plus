require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class OLN < NMEAPlus::Message::NMEA::NMEAMessage
        def omega_pair1
          @fields[1..3].join(",")
        end

        def omega_pair2
          @fields[4..6].join(",")
        end

        def omega_pair3
          @fields[7..9].join(",")
        end

      end
    end
  end
end
