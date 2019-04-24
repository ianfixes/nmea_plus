require 'nmea_plus/message/ais/vdm_payload/vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Base class for binary acknowledgement messages
        # @see VDMMsg7
        # @see VDMMsg13
        class VDMMsgBinaryAcknowledgement < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :ack1_mmsi, 40, 30, :_u
          payload_reader :ack1_sequence_number, 70, 2, :_u
          payload_reader :ack2_mmsi, 72, 30, :_u
          payload_reader :ack2_sequence_number, 102, 2, :_u
          payload_reader :ack3_mmsi, 104, 30, :_u
          payload_reader :ack3_sequence_number, 134, 2, :_u
          payload_reader :ack4_mmsi, 136, 30, :_u
          payload_reader :ack4_sequence_number, 166, 2, :_u

        end
      end
    end
  end
end
