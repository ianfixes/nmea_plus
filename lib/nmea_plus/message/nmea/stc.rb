require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # STC - Time Constant
      class STC < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :time_constant, 1, :_integer
      end
    end
  end
end
