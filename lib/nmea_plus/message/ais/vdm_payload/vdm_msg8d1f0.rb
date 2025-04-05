require "nmea_plus/message/ais/vdm_payload/vdm_msg8_dynamic_payload"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Type 8: Binary Addressed Message Subtype: IFM 0: Text using 6-bit ASCII
        class VDMMsg8d1f0 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg8DynamicPayload
          payload_reader :acknowledge_required?, 56, 1, :_b
          payload_reader :sequence_number, 57, 11, :_u
          payload_reader :text, 68, 906, :_t
        end
      end
    end
  end
end
