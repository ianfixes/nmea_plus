require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # ZCD - Timer
      # Limited utility, no recommended replacement.
      class ZCD < NMEAPlus::Message::NMEA::NMEAMessage
        CONTROL_FLAGS = {
          '+' => :up,
          '-' => :down,
          'V' => :stop
        }.freeze

        # Timer initial value, seconds
        field_reader :initial_time_seconds, 1, :_integer

        # Timer control
        # @!parse attr_reader :control
        # @return [Symbol]
        def control
          CONTROL_FLAGS[@fields[2]]
        end
      end
    end
  end
end
