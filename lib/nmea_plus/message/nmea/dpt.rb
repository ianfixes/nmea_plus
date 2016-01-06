require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # DPT - Depth of Water
      class DPT < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :depth_meters, 1, :_float
        field_reader :offset_distance, 2, :_float
      end
    end
  end
end
