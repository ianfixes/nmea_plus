require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # DRU - Dual Doppler Auxiliary Data
      #
      # Depth, turn rate and % RPM in support of Doppler velocity systems.
      # The use of $--DPT is recommended for depth data,
      # $--RPM for shaft rotation and
      # $--ROT for rate of turn.
      # @see DPT
      # @see RPM
      # @see ROT
      class DRU < NMEAPlus::Message::NMEA::NMEAMessage
        # Depth, meters
        field_reader :depth_meters, 1, :_float

        # Status: Depth
        field_reader :depth_valid?, 2, :_av_boolean

        # Rate of turn, degrees per minute, "-" = port
        field_reader :rate_of_turn_starboard_degrees_per_minute, 3, :_float

        # Status: Rate of turn
        field_reader :rate_of_turn_valid?, 4, :_av_boolean

        # Propeller shaft rotation, % of maximum, "-" = astern
        field_reader :rotation_percentage, 5, :_float
      end
    end
  end
end
