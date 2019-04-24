require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # RPM - Revolutions
      class RPM < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :source_type, 1, :_string
        field_reader :source_id, 2, :_integer
        field_reader :rpm, 3, :_float
        field_reader :forward_pitch_percentage, 4, :_float
        field_reader :valid?, 5, :_av_boolean
      end
    end
  end
end
