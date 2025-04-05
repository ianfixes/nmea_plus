require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # HDT - Heading - True
      # Actual vessel heading in degrees True produced by any device or system producing true heading
      class HDT < NMEAPlus::Message::NMEA::NMEAMessage
        # Heading, degrees True
        field_reader :true_heading_degrees, 1, :_float
      end
    end
  end
end
