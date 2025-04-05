require "nmea_plus/message/ais/vdm_payload/vdm_msg_binary_acknowledgement"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 13: Safety-Related Acknowledgement
        # According to the unoffical spec: "The message layout is identical to a type 7 Binary Acknowledge."
        # @see VDMMsgBinaryAcknowledgement
        class VDMMsg13 < VDMMsgBinaryAcknowledgement; end

      end
    end
  end
end
