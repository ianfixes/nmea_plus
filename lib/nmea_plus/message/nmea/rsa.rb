require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # RSA - Rudder Sensor Angle
      class RSA < NMEAPlus::Message::NMEA::NMEAMessage
        # single rudder or starboard rudder are the same fields
        field_reader :rudder_angle, 1, :_float
        field_reader :rudder_angle_valid?, 2, :_av_boolean
        field_reader :starboard_rudder_angle, 1, :_float
        field_reader :starboard_rudder_angle_valid?, 2, :_av_boolean
        field_reader :port_rudder_angle, 3, :_float
        field_reader :port_rudder_angle_valid?, 4, :_av_boolean
      end
    end
  end
end
