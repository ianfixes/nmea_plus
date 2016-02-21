require_relative 'vdm_msg6_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Type 6: Binary Addressed Message Subtype: IFM 4: Capability reply
        class VDMMsg6d1f4 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload

          # The availibility table for functional IDs; there are 64 boolean entries
          # @!parse attr_reader :fid_availability
          # @return [Array] An array of booleans
          def fid_availability
            (0...128).step(2).to_a.map do |pos|
              _6b_boolean(88 + pos, 1)
            end
          end

        end
      end
    end
  end
end
