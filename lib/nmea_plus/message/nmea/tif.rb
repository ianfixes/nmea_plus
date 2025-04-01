require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TIF - TRANSIT Satellite Initial Flag
      # TRANSIT system is not operational, no recommended replacement
      class TIF < NMEAPlus::Message::NMEA::NMEAMessage
        INITIAL_FLAGS = {
          "A" => :normal_operation,
          "V" => :set_initialization_data,
          "J" => :initialization_data_complete
        }.freeze

        INITIAL_FLAG_DESCRIPTIONS = {
          normal_operation: "Normal operation",
          set_initialization_data: "Set initialization data",
          initialization_data_complete: "Initialization data complete"
        }.freeze

        # Satellite Initial Flag
        # @!parse attr_reader :initial_flag
        # @return [Symbol]
        def initial_flag
          INITIAL_FLAGS[@fields[1]]
        end

        # Description of initial flag
        # @!parse attr_reader :initial_flag_description
        # @return [String]
        def initial_flag_description
          INITIAL_FLAG_DESCRIPTIONS[initial_flag]
        end

      end
    end
  end
end
