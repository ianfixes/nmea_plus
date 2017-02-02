require_relative "zzu"

module NMEAPlus
  module Message
    module NMEA
      # ZEV - Event Timer
      class ZEV < NMEAPlus::Message::NMEA::ZZU
        field_reader :initial_time, 2, :_interval_hms

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
