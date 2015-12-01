require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class HDT < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :true_heading_degrees, 1, :_float
      end
    end
  end
end
