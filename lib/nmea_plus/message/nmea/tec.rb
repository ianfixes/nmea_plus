require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TEC - TRANSIT Satellite Error Code & Doppler Count
      # TRANSIT system is not operational, no recommended replacement.
      class TEC < NMEAPlus::Message::NMEA::NMEAMessage
        # Status: Maximum angle
        field_reader :maximum_angle_flag, 1, :_av_boolean

        # Status: Doppler count
        field_reader :doppler_count_flag, 2, :_av_boolean

        # Status: Iteration number
        field_reader :iteration_number_flag, 3, :_av_boolean
      end
    end
  end
end
