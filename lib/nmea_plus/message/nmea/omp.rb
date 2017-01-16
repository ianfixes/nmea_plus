require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # OMP - OMEGA
      class OMP < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :pair1, 2, :_string
        field_reader :pair2, 4, :_string
        field_reader :pair3, 6, :_string
      end
    end
  end
end
