require "nmea_plus/message/ais/vdm_payload/vdm_msg"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 17: DGNSS Broadcast Binary Message
        class VDMMsg17 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
          payload_reader :longitude, 40, 18, :_I, 60 * 10, 181
          payload_reader :latitude, 58, 17, :_I, 60 * 10, 91
          payload_reader :payload_2b, 80, 736, :_d
          payload_reader :payload_8b, 80, 736, :_T
        end
      end
    end
  end
end
