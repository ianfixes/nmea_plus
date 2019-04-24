require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # VTI - Intended Track
      # Limited utility, no recommended replacement.
      class VTI < NMEAPlus::Message::NMEA::NMEAMessage
        # Intended track, degrees True
        field_reader :intended_track_degrees_true, 1, :_float

        # Intended track, degrees Magnetic
        field_reader :intended_track_degrees_magnetic, 3, :_float

        # Speed made good, knots
        field_reader :speed_made_good_knots, 5, :_float

        # Distance made good, naut. miles
        field_reader :distance_made_good_nautical_miles, 7, :_float
      end
    end
  end
end
