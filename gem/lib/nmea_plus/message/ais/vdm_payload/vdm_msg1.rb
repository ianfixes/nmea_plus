require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsgCNB < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :navigational_status, 38, 4, :_u

          def rate_of_turn
            ret = _i(42, 8)
            return nil if ret == -128
            (_I(42, 8, 3) / 4.733) ** 2
          end

          payload_reader :speed_over_ground, 50, 10, :_U, 1
          payload_reader :position_10m_accuracy?, 60, 1, :_b

          def longitude
            _I(61, 28, 4) / 60
          end

          def latitude
            _U(89, 27, 4) / 60
          end

          payload_reader :course_over_ground, 116, 12, :_U, 1

          def true_heading
            ret = _u(128, 9)
            return nil if ret == 511  # means "not available"
            ret
          end

          payload_reader :time_stamp, 137, 6, :_u
          payload_reader :special_manoeuvre, 143, 2, :_e
          payload_reader :raim?, 148, 1, :_b

        end

        class VDMMsg1 < VDMMsgCNB; end
        class VDMMsg2 < VDMMsgCNB; end
        class VDMMsg3 < VDMMsgCNB; end
      end
    end
  end
end
