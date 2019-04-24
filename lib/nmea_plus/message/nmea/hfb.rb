require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # HFB - Trawl Headrope to Footrope and Bottom
      class HFB < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :headrope_to_footrope_meters, 1, :_float
        field_reader :headrope_to_bottom_meters, 3, :_float
      end
    end
  end
end
