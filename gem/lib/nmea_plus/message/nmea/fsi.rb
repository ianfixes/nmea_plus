require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class FSI < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :transmit_frequency, 1, :_float
        field_reader :receive_frequency, 2, :_float
        field_reader :communications_mode, 3, :_string
        field_reader :power_level, 4, :_float
      end
    end
  end
end
