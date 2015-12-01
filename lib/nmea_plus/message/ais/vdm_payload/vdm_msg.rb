class Class
end

module NMEAPlus
  module Message
    module AIS
      # There are many VDM payload types, and this is their container.  See {VDMMsg}.
      module VDMPayload
        # The base class for the AIS payload (of {NMEAPlus::Message::AIS::VDM}) which can be of many types.
        class VDMMsg
          # @return [String] The raw "armored payload" in the original message
          attr_accessor :payload_bitstring

          # @return [Integer] The number of padding characters required to bring the payload to a 6 bit boundary
          attr_accessor :fill_bits

          # make our own shortcut syntax for payload attributes
          # @param name [String] What the accessor will be called
          # @param start_bit [Integer] The index of first bit of this field in the payload
          # @param length [Integer] The number of bits in this field
          # @param formatter [Symbol] The symbol for the formatting function to apply to the field (optional)
          # @param formatter_arg Any argument necessary for the formatting function
          # @macro [attach] payload_reader
          #   @!attribute [r] $1
          #   @return The field defined by $3 bits starting at bit $2 of the payload, formatted with the function {#$4}($5)
          def self.payload_reader(name, start_bit, length, formatter, formatter_arg = nil)
            if formatter_arg.nil?
              self.class_eval("def #{name};#{formatter}(#{start_bit}, #{length});end")
            else
              self.class_eval("def #{name};#{formatter}(#{start_bit}, #{length}, #{formatter_arg});end")
            end
          end

          payload_reader :message_type, 0, 6, :_u
          payload_reader :repeat_indicator, 6, 2, :_u
          payload_reader :source_mmsi, 8, 30, :_u

          # Convert 6-bit ascii to a character, according to http://catb.org/gpsd/AIVDM.html#_ais_payload_data_types
          # @param ord [Integer] The 6-bit ascii code
          # @return [String] the character for that code
          def _6b_ascii(ord)
            '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_ !"#$%&\'()*+,-./0123456789:;<=>?'[ord]
          end

          # Access part of the payload.  If there aren't bytes, there, return nil
          # else execute a block
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return Nil or whatever is yielded by the block
          # @yield [String] A binary coded string ("010010101" etc)
          def _access(start, length)
            part = @payload_bitstring[start, length]
            return nil if part.nil? || part.empty?
            yield part
          end

          # pull out 6b chunks from the payload, then convert those to their more familar characters
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [String]
          def _6b_string(start, length)
            _bit_slices(start, length, 6).to_a.map(&:join).map { |x| _6b_ascii(x.to_i(2)) }.join
          end

          # pull out 8b chunks from the payload, then convert those to their more familar characters
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [String]
          def _8b_data_string(start, length)
            _bit_slices(start, length, 8).to_a.map(&:join).map { |x| x.to_i(2).chr }.join
          end

          # Slice a part of the payload into binary chunks of a given size
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [Array<String>] Strings representing binary ("01010101" etc) for each slice
          def _bit_slices(start, length, chunk_size)
            _access(start, length) { |bits| bits.chars.each_slice(chunk_size) }
          end

          # convert a 6b string but trim off the 0s ('@')
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [String]
          def _6b_string_nullterminated(start, length)
            _6b_string(start, length).split("@", 2)[0]
          end

          # directly convert a string to a binary number as you'd read it
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [Integer] an unsigned integer value
          def _6b_unsigned_integer(start, length)
            _access(start, length) { |bits| bits.to_i(2) }
          end

          # perform a twos complement operation on part of the payload
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [Integer] an integer value
          def _6b_twoscomplement(start, length)
            # two's complement: flip bits, then add 1
            _access(start, length) { |bits| bits.tr("01", "10").to_i(2) + 1 }
          end

          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [Integer] an integer value
          def _6b_integer(start, length)
            # MSB is 1 for negative
            twoc = _6b_twoscomplement(start, length)
            twoc && twoc * (@payload_bitstring[start] == 0 ? 1 : -1)
          end

          # scale an integer by dividing it by 10^decimal_places
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param decimal_places [Integer] The power of ten to use in scaling the result
          # @return [Integer] an integer value
          def _6b_integer_scaled(start, length, decimal_places)
            _6b_integer(start, length).to_f / (10 ** decimal_places)
          end

          # scale an unsigned integer by dividing it by 10^decimal_places
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param decimal_places [Integer] The power of ten to use in scaling the result
          # @return [Integer] an integer value
          def _6b_unsigned_integer_scaled(start, length, decimal_places)
            _6b_unsigned_integer(start, length).to_f / (10.0 ** decimal_places)
          end

          # Get the value of a bit in the payload
          # @param start [Integer] The index of the first bit in the payload field
          # @param _ [Integer] Doesn't matter.  Here so signatures match; we hard-code 1 because it's 1 bit.
          # @return [bool]
          def _6b_boolean(start, _)
            _access(start, 1) { |bits| bits.to_i == 1 }
          end

          # Return a string representing binary
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [String] e.g. "0101010101011000"
          def _2b_data_string(start, length)
            _access(start, length)
          end

          # use shorthand for data types as defined in http://catb.org/gpsd/AIVDM.html
          alias_method :_u, :_6b_unsigned_integer
          alias_method :_U, :_6b_unsigned_integer_scaled
          alias_method :_i, :_6b_integer
          alias_method :_I, :_6b_integer_scaled
          alias_method :_b, :_6b_boolean
          alias_method :_e, :_6b_unsigned_integer
          alias_method :_t, :_6b_string_nullterminated
          alias_method :_d, :_2b_data_string

        end

        # We haven't defined all the AIS payload types, so this is a catch-all
        class VDMMsgUndefined < VDMMsg; end

      end
    end
  end
end
