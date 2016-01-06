require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # RSD - RADAR System Data
      class RSD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :cursor_range_from_ownship, 9, :_float
        field_reader :cursor_bearing_degrees_clockwise, 10, :_float
        field_reader :range_scale, 11, :_string
        field_reader :range_units, 12, :_string
      end
    end
  end
end
