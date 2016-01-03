require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # CNB - The Common Navigation Block, transmitted by AIS messages 1, 2, and 3.
        class VDMMsgCNB < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :navigational_status, 38, 4, :_u

          # @!parse attr_reader :navigational_status_description
          # @return [String] the human-readable description of navigational status
          def navigational_status_description
            return nil if navigational_status.nil?
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

          # The rate of turn in degrees per minute
          # @!parse attr_reader :rate_of_turn
          # @return [Float]
          def rate_of_turn
            ret = _i(42, 8)
            return nil if ret == -128
            (_I(42, 8, 3) / 4.733) ** 2
          end

          payload_reader :speed_over_ground, 50, 10, :_U, 1
          payload_reader :position_10m_accuracy?, 60, 1, :_b

          # @!parse attr_reader :longitude
          # @return [Float]
          def longitude
            ret = _I(61, 28, 4) / 60
            181 == ret ? nil : ret
          end

          # @!parse attr_reader :latitude
          # @return [Float]
          def latitude
            ret = _I(89, 27, 4) / 60
            91 == ret ? nil : ret
          end

          payload_reader :_course_over_ground, 116, 12, :_U, 1

          # @!parse attr_reader :course_over_ground
          # @return [Float]
          def course_over_ground
            ret = _course_over_ground
            3600 == ret ? nil : ret
          end

          # @!parse attr_reader :true_heading
          # @return [Float]
          def true_heading
            ret = _u(128, 9)
            return nil if ret == 511  # means "not available"
            ret
          end

          payload_reader :_time_stamp, 137, 6, :_u

          # @!parse attr_reader :time_stamp
          # @return [Integer]
          def time_stamp
            ret = _time_stamp
            59 < ret ? nil : ret
          end

          # @!parse attr_reader :position_manual_input?
          # @return [bool]
          def position_manual_input?
            61 == _time_stamp
          end

          # @!parse attr_reader :position_estimated?
          # @return [bool]
          def position_estimated?
            62 == _time_stamp
          end

          # @!parse attr_reader :position_inoperative?
          # @return [bool]
          def position_inoperative?
            63 == _time_stamp
          end

          payload_reader :special_manoeuvre, 143, 2, :_e
          payload_reader :raim?, 148, 1, :_b

        end

        # Position report class A, which is really {VDMMsgCNB}
        class VDMMsg1 < VDMMsgCNB; end

        # Position report class A, which is really {VDMMsgCNB}
        class VDMMsg2 < VDMMsgCNB; end

        # Position report class A, which is really {VDMMsgCNB}
        class VDMMsg3 < VDMMsgCNB; end
      end
    end
  end
end
