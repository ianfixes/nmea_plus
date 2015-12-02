require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsg9 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :altitude_meters, 38, 12, :_u

          payload_reader :speed_over_ground, 50, 10, :_U, 1
          payload_reader :position_10m_accuracy?, 60, 1, :_b

          # @!parse attr_reader :longitude
          # @return [Float]
          def longitude
            _I(61, 28, 4) / 60
          end

          # @!parse attr_reader :latitude
          # @return [Float]
          def latitude
            _U(89, 27, 4) / 60
          end

          payload_reader :course_over_ground, 116, 12, :_U, 1
          payload_reader :time_stamp, 128, 6, :_u
          payload_reader :dte?, 142, 1, :_b

          payload_reader :assigned?, 146, 1, :_b
          payload_reader :raim?, 147, 1, :_b

        end
      end
    end
  end
end
