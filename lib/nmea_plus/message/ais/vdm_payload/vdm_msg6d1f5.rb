require_relative 'vdm_msg6_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Type 6: Binary Addressed Message Subtype: IFM 5: Application acknowledgement to an addressed binary message
        class VDMMsg6d1f5 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload
          payload_reader :received_fm_dac, 88, 10, :_u
          payload_reader :received_fm_fid, 98, 6, :_u
          payload_reader :sequence_number, 104, 11, :_u
          payload_reader :ai_available?, 115, 1, :_b
          payload_reader :ai_response, 116, 3, :_e

          # The AI response description
          # @!parse attr_reader :ai_response_description
          # @return [String] The description of the AI response
          def ai_response_description
            case ai_response
            when 0 then "Unable to respond"
            when 1 then "Reception acknowledged"
            when 2 then "Response to follow"
            when 3 then "Able to respond but currently inhibited"
            else
              "Reserved for future use"
            end
          end

        end
      end
    end
  end
end
