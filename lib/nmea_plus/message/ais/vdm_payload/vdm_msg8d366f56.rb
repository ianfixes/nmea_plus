require 'nmea_plus/message/ais/vdm_payload/vdm_msg8_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Basic decoding of "blue force" encrypted binary messages.
        # Note that this module is incapable of decrypting the messages. It can only deocde and return
        # the encrypted payload to be decrypted elsewhere.
        class VDMMsg8USCGEncrypted < VDMMsg8DynamicPayload
          payload_reader :encrypted_data_2b, 56, 952, :_d
          payload_reader :encrypted_data_6b, 56, 952, :_6b_string
          payload_reader :encrypted_data_8b, 56, 952, :_8b_data_string
        end

        # Type 8: Binary Broadcast Message Subtype: US Coast Guard (USCG) blue force encrypted position report
        class VDMMsg8d366f56 < VDMMsg8USCGEncrypted; end

        # Type 8: Binary Broadcast Message Subtype: US Coast Guard (USCG) blue force encrypted data
        class VDMMsg8d366f57 < VDMMsg8USCGEncrypted; end

      end
    end
  end
end
