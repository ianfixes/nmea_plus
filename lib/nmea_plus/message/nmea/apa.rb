require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # APA - Autopilot Sentence "A"
      #
      # Commonly used by autopilots this sentence contains navigation receiver warning flag status, cross-track-error, waypoint
      # arrival status and initial bearing from origin waypoint to the destination waypoint for the active navigation leg of the
      # journey.
      # Use of $--APB with additional data fields of heading-to-steer and bearing from present position to destination is
      # recommended.
      # @see APB
      class APA < NMEAPlus::Message::NMEA::NMEAMessage
        # Data Status: "OR" of Loran-C Blink and SNR warning flags
        field_reader :no_general_warning?, 1, :_av_boolean

        # Data status: Loran-C Cycle Lock warning flag
        field_reader :no_cyclelock_warning?, 2, :_av_boolean

        # Magnitude of XTE (cross-track-error)
        field_reader :cross_track_error, 3, :_float

        # Direction to steer, L/R
        field_reader :direction_to_steer, 4, :_string

        # XTE units, nautical miles
        field_reader :cross_track_units, 5, :_string

        # Status: arrival circle entered
        field_reader :arrival_circle_entered?, 6, :_av_boolean

        # Status: perpendicular passed at waypoint
        field_reader :perpendicular_passed?, 7, :_av_boolean

        # Bearing origin to destination, Mag.
        field_reader :bearing_origin_to_destination, 8, :_float
        field_reader :compass_type, 9, :_string

        # Destination waypoint ID
        field_reader :destination_waypoint_id, 10, :_string
      end
    end
  end
end
