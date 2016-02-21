require_relative 'vdm_msg6_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Type 6: Binary Addressed Message Subtype: IFM 0: Text using 6-bit ASCII
        class VDMMsg6d1f0 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload
          payload_reader :acknowledge_required?, 88, 1, :_b
          payload_reader :sequence_number, 89, 11, :_u
          payload_reader :text, 100, 906, :_t
        end
      end
    end
  end
end
