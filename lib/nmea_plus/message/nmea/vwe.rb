require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # VWE - Wind Track Efficiency
      # Limited utility, no recommended replacement.
      class VWE < NMEAPlus::Message::NMEA::NMEAMessage
        # Efficiency, percent
        field_reader :efficiency_percent, 1, :_float
      end
    end
  end
end
