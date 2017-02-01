require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VPE - Speed, Dead Reckoned Parallel to True Wind
      class VPE < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :speed_knots, 1, :_float
        field_reader :speed_ms, 3, :_float
      end
    end
  end
end
