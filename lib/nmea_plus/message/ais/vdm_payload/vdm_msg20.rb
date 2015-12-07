require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # Type 20 Data Link Management Message
        class VDMMsg20 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
          payload_reader :offset1, 40, 12, :_u
          payload_reader :reserved_slots1, 52, 4, :_u
          payload_reader :timeout1, 56, 3, :_u
          payload_reader :increment1, 59, 11, :_u
          payload_reader :offset2, 70, 12, :_u
          payload_reader :reserved_slots2, 82, 4, :_u
          payload_reader :timeout2, 86, 3, :_u
          payload_reader :increment2, 89, 11, :_u
          payload_reader :offset3, 100, 12, :_u
          payload_reader :reserved_slots3, 112, 4, :_u
          payload_reader :timeout3, 116, 3, :_u
          payload_reader :increment3, 119, 11, :_u
          payload_reader :offset4, 130, 12, :_u
          payload_reader :reserved_slots4, 142, 4, :_u
          payload_reader :timeout4, 146, 3, :_u
          payload_reader :increment4, 149, 11, :_u
        end
      end
    end
  end
end
