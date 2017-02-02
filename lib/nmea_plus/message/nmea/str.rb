require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # STR - Tracking Reference
      #
      # Transmitted prior to a sentence containing velocity-based data to indicate when velocity is measured over-the-ground or
      # relative to the water.
      #
      # The use of appropriate ground or water-referenced approved sentences such as
      # $--VBW, $--VHW or $--VTG is recommended.
      # @see VBW
      # @see VHW
      # @see VTG
      class STR < NMEAPlus::Message::NMEA::NMEAMessage

        # @!parse attr_reader :tracking_reference
        # @return [Symbol]
        def tracking_reference
          NMEA::NMEAMessage._av_boolean(@fields[1]) ? :ground : :water

        end

        # Description of tracking reference
        # @!parse attr_reader :tracking_reference_description
        # @return [String]
        def tracking_reference_description
          case tracking_reference
          when :ground then "Ground reference"
          when :water then "Water reference"
          end
        end

      end
    end
  end
end
