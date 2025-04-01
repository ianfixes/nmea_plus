require 'nmea_plus/message/ais/vdm_payload/vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Base class for "Class B CS Position Report" messages (18 and 19)
        # @see NMEAPlus::Message::AIS::VDMPayload::VDMMsg18
        # @see NMEAPlus::Message::AIS::VDMPayload::VDMMsg19
        class VDMMsgClassBCSPosition < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
          payload_reader :speed_over_ground, 46, 10, :_U, 10
          payload_reader :position_10m_accuracy?, 56, 1, :_b
          payload_reader :longitude, 57, 28, :_I, 60 * (10**4), 181
          payload_reader :latitude, 85, 27, :_I, 60 * (10**4), 91
          payload_reader :course_over_ground, 112, 12, :_U, 10
          payload_reader :true_heading, 124, 9, :_u, 511
          payload_reader :time_stamp, 133, 6, :_u
        end

      end
    end
  end
end
