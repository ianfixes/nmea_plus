require_relative 'vdm_msg'
require_relative 'vdm_msg8d1f0'
require_relative 'vdm_msg8d1f22'
require_relative 'vdm_msg8d1f31'
require_relative 'vdm_msg8d200f10'
require_relative 'vdm_msg8d366f56'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 8: Binary Broadcast Message
        class VDMMsg8 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :designated_area_code, 40, 10, :_u
          payload_reader :functional_id, 50, 6, :_u

          # Dynamic Payload containing fields for the appropriate message 8 subtype.
          # This is a factory method for the container class
          # @!parse attr_reader :dp
          # @return [VDMMsg8DynamicPayload]
          def dp
            ret = _dynamic_payload_container
            ret.payload_bitstring = payload_bitstring
            ret.fill_bits = fill_bits
            ret
          end

          # Dynamically calculate what message subtype to use
          # which depends on the designated_area_code and functional_id
          # @private
          def _dynamic_payload_container
            class_identifier = "NMEAPlus::Message::AIS::VDMPayload::VDMMsg8d#{designated_area_code}f#{functional_id}"
            ret = _object_by_name(class_identifier)
            return ret unless ret.nil?

            # 316 / 366
            if designated_area_code == 316
              class_identifier = "NMEAPlus::Message::AIS::VDMPayload::VDMMsg8d366f#{functional_id}"
              ret = _object_by_name(class_identifier)
              return ret unless ret.nil?
            end

            _object_by_name("NMEAPlus::Message::AIS::VDMPayload::VDMMsg8Undefined") # generic
          end

        end
      end
    end
  end
end
