require 'nmea_plus/message/ais/vdm_payload/vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 27: Long Range AIS Broadcast message
        class VDMMsg27 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :position_10m_accuracy?, 38, 1, :_b
          payload_reader :raim?, 39, 1, :_b
          payload_reader :navigational_status, 40, 4, :_u

          # @!parse attr_reader :navigational_status_description
          # @return [String] the human-readable description of navigational status
          def navigational_status_description
            get_navigational_status_description(navigational_status)
          end

          payload_reader :longitude, 44, 18, :_I, 60 * 10, 181
          payload_reader :latitude, 62, 17, :_I, 60 * 10, 91
          payload_reader :speed_over_ground, 79, 6, :_u
          payload_reader :course_over_ground, 85, 9, :_u, 511
          payload_reader :gnss?, 94, 1, :_b

        end
      end
    end
  end
end
