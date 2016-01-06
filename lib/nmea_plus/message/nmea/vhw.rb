require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VHW - Water speed and heading
      class VHW < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :degrees_true, 1, :_float
        field_reader :degrees_magnetic, 3, :_float
        field_reader :water_speed_knots, 5, :_float
        field_reader :water_speed_kmh, 7, :_float
      end
    end
  end
end
