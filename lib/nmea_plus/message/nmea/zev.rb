require_relative "zzu"

module NMEAPlus
  module Message
    module NMEA
      # ZEV - Event Timer
      # Limited utility, no recommended replacement.
      class ZEV < NMEAPlus::Message::NMEA::ZZU
        # Timer initial value
        field_reader :initial_time, 2, :_interval_hms

        # Timer control
        # @!parse attr_reader :control
        # @return [Symbol]
        def control
          case @fields[3]
          when '+' then :up
          when '-' then :down
          when 'V' then :stop
          end
        end
      end
    end
  end
end
