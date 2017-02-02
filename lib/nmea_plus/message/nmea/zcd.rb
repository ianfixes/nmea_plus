require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # ZCD - Timer
      # Limited utility, no recommended replacement.
      class ZCD < NMEAPlus::Message::NMEA::NMEAMessage
        # Timer initial value, seconds
        field_reader :initial_time_seconds, 1, :_integer

        # Timer control
        # @!parse attr_reader :control
        # @return [Symbol]
        def control
          case @fields[2]
          when '+' then :up
          when '-' then :down
          when 'V' then :stop
          end
        end
      end
    end
  end
end
