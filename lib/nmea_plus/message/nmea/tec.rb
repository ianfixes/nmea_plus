require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TEC - TRANSIT Satellite Error Code & Doppler Count
      class TEC < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :maximum_angle_flag, 1, :_av_boolean
        field_reader :doppler_count_flag, 2, :_av_boolean
        field_reader :iteration_number_flag, 3, :_av_boolean
      end
    end
  end
end
