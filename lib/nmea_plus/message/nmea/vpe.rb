require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # VPE - Speed, Dead Reckoned Parallel to True Wind
      # Limited utility, no recommended replacement.
      class VPE < NMEAPlus::Message::NMEA::NMEAMessage
        # Speed, knots, "-" = downwind
        field_reader :speed_knots, 1, :_float

        # Speed, meters/second, "-" = downwind
        field_reader :speed_ms, 3, :_float
      end
    end
  end
end
