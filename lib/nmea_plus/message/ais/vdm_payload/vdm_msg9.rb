require 'nmea_plus/message/ais/vdm_payload/vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 9: Standard SAR Aircraft Position Report
        class VDMMsg9 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :altitude_meters, 38, 12, :_u, 4095

          payload_reader :speed_over_ground, 50, 10, :_U, 1, 1023
          payload_reader :position_10m_accuracy?, 60, 1, :_b
          payload_reader :longitude, 61, 28, :_I, 60 * (10**4), 181
          payload_reader :latitude, 89, 27, :_I, 60 * (10**4), 91
          payload_reader :course_over_ground, 116, 12, :_U, 10
          payload_reader :time_stamp, 128, 6, :_u
          payload_reader :dte_ready?, 142, 1, :_nb

          payload_reader :assigned?, 146, 1, :_b
          payload_reader :raim?, 147, 1, :_b

        end
      end
    end
  end
end
