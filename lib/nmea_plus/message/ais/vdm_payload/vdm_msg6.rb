require_relative 'vdm_msg'
require_relative 'vdm_msg6d235f10'
require_relative 'vdm_msg6d1022f61'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 6: Binary Addressed Message
        class VDMMsg6 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :sequence_number, 38, 2, :_u
          payload_reader :destination_mmsi, 40, 30, :_u
          payload_reader :retransmitted?, 70, 1, :_b
          payload_reader :designated_area_code, 72, 10, :_u
          payload_reader :functional_id, 82, 6, :_u

          # Dynamic Payload containing fields for the appropriate message 6 subtype.
          # This is a factory method for the container class
          # @!parse attr_reader :dp
          # @return [VDMPayload::VDMMsg::VDMMsg8DynamicPayload]
          def dp
            ret = _dynamic_payload_container
            ret.payload_bitstring = payload_bitstring
            ret.fill_bits = fill_bits
            ret
          end

          # Dynamically calculate what message subtype to use
          # which depends on the designated_area_code and functional_id
          def _dynamic_payload_container
            class_identifier = "NMEAPlus::Message::AIS::VDMPayload::VDMMsg6d#{designated_area_code}f#{functional_id}"
            ret = _object_by_name(class_identifier)
            return ret unless ret.nil?

            _object_by_name("NMEAPlus::Message::AIS::VDMPayload::VDMMsg8Undefined") # generic
          end

        end

        # Base class for dynamic payloads (subtypes) of AIS VDM message 6
        class VDMMsg6DynamicPayload < NMEAPlus::Message::AIS::VDMPayload::Payload; end

        # Placeholder for undefined message 8 payload subtypes
        class VDMMsg6Undefined < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload
          payload_reader :application_data_2b, 56, 952, :_d
          payload_reader :application_data_6b, 56, 952, :_6b_string
          payload_reader :application_data_8b, 56, 952, :_8b_data_string
        end

      end
    end
  end
end
