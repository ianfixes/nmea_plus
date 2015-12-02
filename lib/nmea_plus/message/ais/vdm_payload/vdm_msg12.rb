require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # Type 12: Addressed Safety-Related Message
        class VDMMsg12 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :sequence_number, 38, 2, :_u
          payload_reader :destination_mmsi, 40, 30, :_u
          payload_reader :retransmit?, 70, 1, :_b

          # Safety message
          payload_reader :text, 72, 936, :_t
        end
      end
    end
  end
end
