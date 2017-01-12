require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # DRU - Dual Doppler Auxiliary Data
      class DRU < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :depth_meters, 1, :_float
        field_reader :depth_valid?, 2, :_av_boolean
        field_reader :rate_of_turn_starboard_degrees_per_minute, 3, :_float
        field_reader :rate_of_turn_valid?, 4, :_av_boolean
        field_reader :rotation_percentage, 5, :_float
      end
    end
  end
end
