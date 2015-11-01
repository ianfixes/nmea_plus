require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class GTD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :difference1, 1, :_float
        field_reader :difference2, 2, :_float
        field_reader :difference3, 3, :_float
        field_reader :difference4, 4, :_float
        field_reader :difference5, 5, :_float
      end
    end
  end
end
