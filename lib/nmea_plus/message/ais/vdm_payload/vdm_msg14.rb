require "nmea_plus/message/ais/vdm_payload/vdm_msg"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 14: Safety-Related Broadcast Message
        class VDMMsg14 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          # Safety message
          payload_reader :text, 40, 968, :_t
        end
      end
    end
  end
end
