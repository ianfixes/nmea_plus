require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class XTE < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :no_general_warning?, 1, :_av_boolean
        field_reader :no_cyclelock_warning?, 2, :_av_boolean
        field_reader :cross_track_error, 3, :_float
        field_reader :direction_to_steer, 4, :_string
        field_reader :cross_track_units, 5, :_string
        field_reader :faa_mode, 6, :_string
      end
    end
  end
end
