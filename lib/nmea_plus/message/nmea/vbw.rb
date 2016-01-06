require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VBW - Dual Ground/Water Speed
      class VBW < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :longitudinal_water_speed, 1, :_float
        field_reader :transverse_water_speed, 2, :_float
        field_reader :water_speed_valid?, 3, :_av_boolean
        field_reader :longitudinal_ground_speed, 4, :_float
        field_reader :transverse_ground_speed, 5, :_float
        field_reader :ground_speed_valid?, 6, :_av_boolean
      end
    end
  end
end
