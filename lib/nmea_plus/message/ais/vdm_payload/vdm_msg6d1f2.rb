require_relative 'vdm_msg6_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Type 6: Binary Addressed Message Subtype: IFM 2: Interrogation for a specific FM
        class VDMMsg6d1f2 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload
          payload_reader :requested_dac, 88, 10, :_u
          payload_reader :requested_fid, 98, 6, :_u
        end
      end
    end
  end
end
