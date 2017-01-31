require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TIF - TRANSIT Satellite Initial Flag
      class TIF < NMEAPlus::Message::NMEA::NMEAMessage

        # @!parse attr_reader :initial_flag
        # @return [Symbol]
        def initial_flag
          case @fields[1]
          when 'A' then :normal_operation
          when 'V' then :set_initialization_data
          when 'J' then :initialization_data_complete
          end
        end

        # Description of initial flag
        # @!parse attr_reader :initial_flag_description
        # @return [String]
        def initial_flag_description
          case initial_flag
          when :normal_operation then 'Normal operation'
          when :set_initialization_data then 'Set initialization data'
          when :initialization_data_complete then 'Initialization data complete'
          end
        end

      end
    end
  end
end
