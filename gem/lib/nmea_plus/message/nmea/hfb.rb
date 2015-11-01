require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class HFB < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :headrope_to_footrope_meters, 1, :_float
        field_reader :headrope_to_bottom_meters, 3, :_float
      end
    end
  end
end
