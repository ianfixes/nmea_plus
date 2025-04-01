require 'nmea_plus/message/nmea/zzu'

module NMEAPlus
  module Message
    module NMEA
      # ZEV - Event Timer
      # Limited utility, no recommended replacement.
      class ZEV < NMEAPlus::Message::NMEA::ZZU
        CONTROL_FLAGS = {
          '+' => :up,
          '-' => :down,
          'V' => :stop
        }.freeze

        # Timer initial value
        field_reader :initial_time, 2, :_interval_hms

        # Timer control
        # @!parse attr_reader :control
        # @return [Symbol]
        def control
          CONTROL_FLAGS[@fields[3]]
        end
      end
    end
  end
end
