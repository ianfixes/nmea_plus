require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 15: Interrogation
        class VDMMsg15 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
          payload_reader :interrogation1_mmsi, 40, 30, :_u
          payload_reader :interrogation1_type1, 70, 6, :_u
          payload_reader :interrogation1_offset1, 76, 12, :_u

          payload_reader :interrogation1_type2, 90, 6, :_u
          payload_reader :interrogation1_offset2, 96, 12, :_u

          payload_reader :interrogation2_mmsi, 110, 30, :_u
          payload_reader :interrogation2_type, 140, 6, :_u
          payload_reader :interrogation2_offset, 146, 12, :_u
        end
      end
    end
  end
end
