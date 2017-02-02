require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SNC - Navigation Calculation Basis
      # Basis for navigation calculations, Great Circle or Rhumb Line.
      #
      # Limited utility, no recommended replacement
      class SNC < NMEAPlus::Message::NMEA::NMEAMessage

        # Basis for navigation calculations, Great Circle or Rhumb Line
        # @!parse attr_reader :calculation_basis
        # @return [Symbol]
        def calculation_basis
          case @fields[1]
          when 'G' then :great_circle
          when 'R' then :rhumb_line
          end
        end

        # Description of basis for navigation calculations
        # @!parse attr_reader :calculation_basis_description
        # @return [String]
        def calculation_basis_description
          case calculation_basis
          when :great_circle then "Great Circle"
          when :rhumb_line then "Rhumb Line"
          end
        end

      end
    end
  end
end
