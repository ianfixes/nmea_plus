require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # SGD - Position Accuracy Estimate
      #
      # Estimate of position accuracy based on geometric dilution of precision (GDOP)
      # and system noise, in feet and nautical miles.
      #
      # Limited utility, no recommended replacement.
      class SGD < NMEAPlus::Message::NMEA::NMEAMessage
        # Accuracy, nautical miles
        field_reader :accuracy_feet, 1, :_float

        # Accuracy, feet
        field_reader :accuracy_nautical_miles, 3, :_float
      end
    end
  end
end
