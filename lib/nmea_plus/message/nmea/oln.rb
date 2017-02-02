require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # OLN - Omega Lane Numbers
      # Omega Lines of Positions (LOPs).
      #
      # OMEGA system is not operational, no recommended replacement.
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

        # Pair 1
        # @!parse attr_reader :omega_pair1
        # @return [OmegaLanePair]
        def omega_pair1
          OmegaLanePair.new(@fields[1..3])
        end

        # Pair 2
        # @!parse attr_reader :omega_pair2
        # @return [OmegaLanePair]
        def omega_pair2
          OmegaLanePair.new(@fields[4..6])
        end

        # Pair 3, AB-GH
        # @!parse attr_reader :omega_pair3
        # @return [OmegaLanePair]
        def omega_pair3
          OmegaLanePair.new(@fields[7..9])
        end

        # @!parse attr_reader :omega_pairs
        # @return [Array<OmegaLanePair>]
        def omega_pairs
          [omega_pair1, omega_pair2, omega_pair3]
        end

      end
    end
  end
end
