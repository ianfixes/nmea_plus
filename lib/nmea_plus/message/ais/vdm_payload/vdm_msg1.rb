require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsgCNB < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :navigational_status, 38, 4, :_u

          def navigational_status_description
            case navigational_status
            when 0 then return "Under way using engine"
            when 1 then return "At anchor"
            when 2 then return "Not under command"
            when 3 then return "Restricted manoeuverability"
            when 4 then return "Constrained by her draught"
            when 5 then return "Moored"
            when 6 then return "Aground"
            when 7 then return "Engaged in Fishing"
            when 8 then return "Under way sailing"
            when 14 then return "AIS-SART active"
            else
              return "undefined"
            end
          end

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
