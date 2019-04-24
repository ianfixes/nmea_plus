require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # OLW - Omega Lane Width
      #
      # OMEGA system is not operational, no recommended replacement.
      class OLW < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :width_nautical_miles, 1, :_float
        field_reader :width_meters, 3, :_float
      end
    end
  end
end
