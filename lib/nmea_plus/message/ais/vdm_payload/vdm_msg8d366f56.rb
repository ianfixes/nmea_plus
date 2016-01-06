require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsg8USCGEncrypted < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
          payload_reader :encrypted_data_2b, 56, 952, :_d
          payload_reader :encrypted_data_6b, 56, 952, :_6b_string
          payload_reader :encrypted_data_8b, 56, 952, :_8b_data_string
        end

        # Type 8: Binary Broadcast Message Subtype: US Coast Guard (USCG) blue force encrypted position report
        class VDMMsg8d366f56 < VDMMsg8USCGEncrypted
          payload_reader :encrypted_data_2b, 56, 952, :_d
          payload_reader :encrypted_data_6b, 56, 952, :_6b_string
          payload_reader :encrypted_data_8b, 56, 952, :_8b_data_string
        end

        # Type 8: Binary Broadcast Message Subtype: US Coast Guard (USCG) blue force encrypted data
        class VDMMsg8d366f57 < VDMMsg8USCGEncrypted
          payload_reader :encrypted_data_2b, 56, 952, :_d
          payload_reader :encrypted_data_6b, 56, 952, :_6b_string
          payload_reader :encrypted_data_8b, 56, 952, :_8b_data_string
        end
      end
    end
  end
end
