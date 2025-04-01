require "nmea_plus/message/ais/vdm"

module NMEAPlus
  module Message
    module AIS

      # VDO - Ownship Vessel Data Message
      # This message type thinly wraps AIS payloads.
      # @see NMEAPlus::Message::AIS::VDMPayload::VDMMsg
      class VDO < NMEAPlus::Message::AIS::VDM
      end
    end
  end
end
