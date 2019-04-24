require 'nmea_plus/message/ais/vdm_payload/vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 12: Addressed Safety-Related Message
        class VDMMsg12 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :sequence_number, 38, 2, :_u
          payload_reader :destination_mmsi, 40, 30, :_u
          payload_reader :retransmit?, 70, 1, :_b

          # Safety message as a null-terminated string
          payload_reader :text, 72, 936, :_t

          # Safety message as data
          payload_reader :data, 72, 936, :_tt
        end
      end
    end
  end
end
