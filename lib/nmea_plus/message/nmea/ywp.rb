require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # YWP - Water Propagation Speed
      class YWP < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :speed_feet_second, 1, :_float
        field_reader :speed_ms, 3, :_float
      end
    end
  end
end
