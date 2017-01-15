require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # HCC - Compass Heading
      class HCC < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :compass_heading_degrees, 1, :_float
      end
    end
  end
end
