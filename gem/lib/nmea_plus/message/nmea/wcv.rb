require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class WCV < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :velocity_knots, 1, :_float
        field_reader :waypoint_id, 3, :_string
      end
    end
  end
end
