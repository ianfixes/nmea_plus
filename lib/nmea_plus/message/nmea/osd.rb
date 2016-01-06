require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # OSD - Own Ship Data
      class OSD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :heading_degrees_true, 1, :_float
        field_reader :valid?, 2, :_av_boolean
        field_reader :course_degrees_true, 3, :_float
        field_reader :course_reference, 4, :_string
        field_reader :vessel_speed, 5, :_float
        field_reader :speed_reference, 6, :_string
        field_reader :vessel_set_degrees_true, 7, :_float
        field_reader :vessel_drift_speed, 8, :_float
        field_reader :vessel_drift_speed_units, 9, :_string
      end
    end
  end
end
