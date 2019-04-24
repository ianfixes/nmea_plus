require 'nmea_plus/message/ais/vdm_payload/vdm_msg6_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Type 6: Binary Addressed Message Subtype: IFM 3: Capability interrogation
        class VDMMsg6d1f3 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload
          payload_reader :requested_dac, 88, 10, :_u
        end
      end
    end
  end
end
