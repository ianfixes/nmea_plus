require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # YWP - Water Propagation Speed
      # Limited utility, no recommended replacement
      class YWP < NMEAPlus::Message::NMEA::NMEAMessage
        # Speed, feet/second
        field_reader :speed_feet_second, 1, :_float

        # Speed, meters/second
        field_reader :speed_ms, 3, :_float
      end
    end
  end
end
