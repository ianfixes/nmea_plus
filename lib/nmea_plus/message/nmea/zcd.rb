require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # ZCD - Timer
      class ZCD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :initial_time_seconds, 1, :_integer

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
