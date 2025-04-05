require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # RTE - Routes
      class RTE < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :total_messages, 1, :_integer
        field_reader :message_number, 2, :_integer
        field_reader :mode, 3, :_string

        # @!parse attr_reader :waypoints
        # @return [Array<Integer>]
        def waypoints
          @fields[4..-1].map(&:to_i)
        end
      end
    end
  end
end
