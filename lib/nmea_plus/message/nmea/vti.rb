require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # VTI - Intended Track
      class VTI < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :intended_track_degrees_true, 1, :_float
        field_reader :intended_track_degrees_magnetic, 3, :_float
        field_reader :speed_made_good_knots, 5, :_float
        field_reader :distance_made_good_nautical_miles, 7, :_float
      end
    end
  end
end
