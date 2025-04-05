require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # HSC - Heading Steering Command
      class HSC < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :true_heading_degrees, 1, :_float
        field_reader :magnetic_heading_degrees, 3, :_float
      end
    end
  end
end
