require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # VTA - Actual Track
      # Limited utility, possible use of $--VTG for a portion of the data.
      class VTA < NMEAPlus::Message::NMEA::NMEAMessage
        # Track made good, degrees True
        field_reader :track_degrees_true, 1, :_float

        # Track made good, degrees Magnetic
        field_reader :track_degrees_magnetic, 3, :_float

        # Speed made good, knots
        field_reader :speed_made_good_knots, 5, :_float

        # Distance made good, naut. miles
        field_reader :distance_made_good_nautical_miles, 7, :_float
      end
    end
  end
end
