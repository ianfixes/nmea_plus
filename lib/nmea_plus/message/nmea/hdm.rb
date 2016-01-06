require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # HDM - Heading - Magnetic
      class HDM < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :magnetic_heading_degrees, 1, :_float
      end
    end
  end
end
