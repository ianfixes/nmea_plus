require_relative "base_ais"

=begin boilerplate for vdm payload objects
require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsg5 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

        end
      end
    end
  end
end

=end

require_relative "vdm_payload/vdm_msg1"
require_relative "vdm_payload/vdm_msg5"
require_relative "vdm_payload/vdm_msg8"


module NMEAPlus
  module Message
    module AIS
      class VDM < NMEAPlus::Message::AIS::AISMessage
        field_reader :total_messages, 1, :_integer
        field_reader :message_number, 2, :_integer
        field_reader :message_id, 3, :_string
        field_reader :channel_code, 4, :_string
        field_reader :raw_ais_payload, 5, :_string
        field_reader :ais_payload_fill_bits, 6, :_integer

        def ais
          # factory method: find the appropriate message type class and instantiate it
          p = full_dearmored_ais_payload
          ret = _payload_container(p[0, 6].to_i(2))
          ret.payload_bitstring = p
          ret.fill_bits = last_ais_fill_bits
          ret
        end

        # the full encoded payload as it was received
        def full_armored_ais_payload
          # get the full message and fill bits for the last one
          ptr = self
          ret = ""
          loop do
            ret << ptr.raw_ais_payload
            break if ptr.next_part.nil?
            ptr = ptr.next_part
          end
          ret
        end

        # a binary string ("0010101110110") representing the dearmored payload
        def full_dearmored_ais_payload
          data = full_armored_ais_payload
          out = ""
          # dearmor all but the last byte, then apply the fill bits to the last byte
          data[0..-2].each_char { |c| out << _dearmor6b(c) }
          out << _dearmor6b(data[-1], 6 - last_ais_fill_bits)
          out
        end

        def last_ais_fill_bits
          # get the fill bits for the last message in the sequence
          ptr = self
          fill_bits = nil
          loop do
            fill_bits = ptr.ais_payload_fill_bits
            break if ptr.next_part.nil?
            ptr = ptr.next_part
          end
          fill_bits.to_i
        end

        # perform the 6-bit to 8-bit conversion defined in the spec
        def _dearmor6b(c, len = 6)
          val = c.ord
          if val >= 96
            ret = val - 56
          else
            ret = val - 48
          end
          ret.to_s(2).rjust(6, "0")[0..(len - 1)]
        end

        def _payload_container(message_type_id)
          class_identifier = "NMEAPlus::Message::AIS::VDMPayload::VDMMsg#{message_type_id}"
          Object::const_get(class_identifier).new
        rescue ::NameError
          class_identifier = "NMEAPlus::Message::AIS::VDMPayload::VDMMsgUndefined" # generic
          Object::const_get(class_identifier).new
        end
      end
    end
  end
end
