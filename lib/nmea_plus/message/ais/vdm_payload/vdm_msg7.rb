require 'nmea_plus/message/ais/vdm_payload/vdm_msg_binary_acknowledgement'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 7: Binary Acknowledge
        # @see VDMMsgBinaryAcknowledgement
        class VDMMsg7 < VDMMsgBinaryAcknowledgement; end

      end
    end
  end
end
