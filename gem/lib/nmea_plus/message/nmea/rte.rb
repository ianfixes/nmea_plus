require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class RTE < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :total_messages, 1, :_integer
        field_reader :message_number, 2, :_integer
        field_reader :mode, 3, :_string
        def waypoints
          @fields[4..-1].map {|w| w.to_i}
        end
      end
    end
  end
end
