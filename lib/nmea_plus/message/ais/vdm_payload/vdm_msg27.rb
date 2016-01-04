require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # Type 27: Long Range AIS Broadcast message
        class VDMMsg27 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :position_10m_accuracy?, 38, 1, :_b
          payload_reader :raim?, 39, 1, :_b
          payload_reader :navigational_status, 40, 4, :_u

          # @!parse attr_reader :navigational_status_description
          # @return [String] the human-readable description of navigational status
          def navigational_status_description
            get_navigational_status_description(navigational_status)
          end

          # @!parse attr_reader :longitude
          # @return [Float]
          def longitude
            ret = _I(44, 18, 1) / 60
            181 == ret ? nil : ret
          end

          # @!parse attr_reader :latitude
          # @return [Float]
          def latitude
            ret = _I(62, 17, 1) / 60
            91 == ret ? nil : ret
          end

          payload_reader :speed_over_ground, 79, 6, :_u

          # @!visibility private
          payload_reader :_course_over_ground, 85, 9, :_u

          # @!parse attr_reader :course_over_ground
          # @return [Float]
          def course_over_ground
            ret = _course_over_ground
            511 == ret ? nil : ret
          end

          payload_reader :gnss?, 94, 1, :_b

        end
      end
    end
  end
end
