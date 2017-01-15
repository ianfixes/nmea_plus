require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # OLN - Omega Lane Numbers
      class OLN < NMEAPlus::Message::NMEA::NMEAMessage
        # container for Omega lane indicators
        class OmegaLanePair
          # @return [String]
          attr_accessor :label

          # first item in the pair
          # @return [Float]
          attr_accessor :first

          # second item in the pair
          # @return [Float]
          attr_accessor :second

          # @param arr [Array] a string and 2 integers
          def initialize(arr)
            @label  = arr[0]
            @first  = arr[1].to_i
            @second = arr[2].to_i
          end
        end

        def omega_pair1
          OmegaLanePair.new(@fields[1..3])
        end

        def omega_pair2
          OmegaLanePair.new(@fields[4..6])
        end

        def omega_pair3
          OmegaLanePair.new(@fields[7..9])
        end

      end
    end
  end
end
