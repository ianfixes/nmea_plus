require 'nmea_plus/message/ais/vdm_payload/vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 10: UTC/Date Inquiry
        class VDMMsg10 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :destination_mmsi, 40, 30, :_u
        end
      end
    end
  end
end
