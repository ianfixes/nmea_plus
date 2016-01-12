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
            get_navigational_status_description(navigational_status)
          end

          # The rate of turn in degrees per minute
          # @!parse attr_reader :rate_of_turn
          # @return [Float]
          def rate_of_turn
            ret = _i(42, 8) # spec is wrong, we don't use I3
            return nil if ret == -128
            negative = ret < 0
            (ret / 4.733)**2 * (negative ? -1 : 1)
          end

          payload_reader :speed_over_ground, 50, 10, :_U, 10
          payload_reader :position_10m_accuracy?, 60, 1, :_b
          payload_reader :longitude, 61, 28, :_I, 60 * 10**4, 181
          payload_reader :latitude, 89, 27, :_I, 60 * 10**4, 91
          payload_reader :course_over_ground, 116, 12, :_U, 10, 3600
          payload_reader :true_heading, 128, 9, :_u, 511

          # @!visibility private
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

        # AIS Type 1: Position report class A, which is really {VDMMsgCNB}
        class VDMMsg1 < VDMMsgCNB; end

        # AIS Type 2: Position report class A, which is really {VDMMsgCNB}
        class VDMMsg2 < VDMMsgCNB; end

        # AIS Type 3: Position report class A, which is really {VDMMsgCNB}
        class VDMMsg3 < VDMMsgCNB; end
      end
    end
  end
end
