require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # Type 8: Binary Broadcast Message
        class VDMMsg8 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
          payload_reader :designated_area_code, 40, 10, :_u
          payload_reader :functional_id, 50, 6, :_u
          payload_reader :application_data_2b, 56, 952, :_d
          payload_reader :application_data_6b, 56, 952, :_6b_string
          payload_reader :application_data_8b, 56, 952, :_8b_data_string

        end
      end
    end
  end
end
