
module NMEAPlus
  module Message
    module AIS

      # This module contains all the VDM payload types and subtypes.
      # @see VDMMsg
      module VDMPayload
        # Basic tools for interpreting the armored (binary) payload encoding of AIS.
        # This class provides convenience functions for accessing the fields as the appropriate data type,
        # as well as logic for AIS bit-level formats
        class Payload

          def initialize; end

          # @return [String] The raw "armored payload" in the original message
          attr_accessor :payload_bitstring

          # @return [Integer] The number of padding characters required to bring the payload to a 6 bit boundary
          attr_accessor :fill_bits

          # Enable a shortcut syntax for AIS payload attributes, in the style of `attr_accessor` metaprogramming.
          # This is used to create a named field pointing to a specific bit range in the payload, applying
          # a specific formatting function with up to 3 arguments as necessary
          # @param name [String] What the accessor will be called
          # @param start_bit [Integer] The index of first bit of this field in the payload
          # @param length [Integer] The number of bits in this field
          # @param formatter [Symbol] The symbol for the formatting function to apply to the field (optional)
          # @param fmt_arg Any argument necessary for the formatting function
          # @param fmt_arg2 Any other argument necessary for the formatting function
          # @param fmt_arg3 Any other argument necessary for the formatting function
          # @return [void]
          # @macro [attach] payload_reader
          #   @!attribute [r] $1
          #   @return The field defined by the $3 bits starting at payload bit $2, formatted with the function {#$4}($5, $6, $7)
          def self.payload_reader(name, start_bit, length, formatter, fmt_arg = nil, fmt_arg2 = nil, fmt_arg3 = nil)
            args = [start_bit, length]
            args << fmt_arg unless fmt_arg.nil?
            args << fmt_arg2 unless fmt_arg2.nil?
            args << fmt_arg3 unless fmt_arg3.nil?
            self.class_eval("def #{name};#{formatter}(#{args.join(', ')});end")
          end

          # Return an object by its class name, or nil if it isn't defined
          def _object_by_name(class_identifier)
            Object::const_get(class_identifier).new
          rescue ::NameError
            nil
          end

          # Convert 6-bit ascii to a character, according to http://catb.org/gpsd/AIVDM.html#_ais_payload_data_types
          # @param ord [Integer] The 6-bit ascii code
          # @return [String] the character for that code
          def _6b_ascii(ord)
            '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_ !"#$%&\'()*+,-./0123456789:;<=>?'[ord]
          end

          # Access part of the payload.
          # If there aren't bytes, there, return nil.  Else, execute a block
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
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [String]
          def _6b_string(start, length)
            _bit_slices(start, length, 6).to_a.map(&:join).map { |x| _6b_ascii(x.to_i(2)) }.join
          end

          # pull out 8b chunks from the payload, then convert those to their more familar characters.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [String]
          def _8b_data_string(start, length)
            _bit_slices(start, length, 8).to_a.map(&:join).map { |x| x.to_i(2).chr }.join
          end

          # Slice a part of the payload into binary chunks of a given size.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [Array<String>] Strings representing binary ("01010101" etc) for each slice
          def _bit_slices(start, length, chunk_size)
            _access(start, length) { |bits| bits.chars.each_slice(chunk_size) }
          end

          # convert a 6b string but trim off the 0s ('@').
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [String]
          def _6b_string_nullterminated(start, length)
            _6b_string(start, length).split("@", 2)[0]
          end

          # directly convert a string to a binary number as you'd read it.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param equiv_nil [Integer] If applicable, the value for this field that would indicate nil
          # @return [Integer] an unsigned integer value
          def _6b_unsigned_integer(start, length, equiv_nil = nil)
            ret = _access(start, length) { |bits| bits.to_i(2) }
            return nil if ret == equiv_nil
            ret
          end

          # perform a twos complement operation on part of the payload.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param equiv_nil [Integer] If applicable, the value for this field that would indicate nil
          # @return [Integer] an integer value
          def _6b_integer(start, length, equiv_nil = nil)
            case @payload_bitstring[start]
            when "0"
              _6b_unsigned_integer(start, length, equiv_nil)
            when "1"
              # MSB is 1 for negative
              # two's complement: flip bits, then add 1
              ret = _access(start, length) { |bits| (bits.tr("01", "10").to_i(2) + 1) * -1 }
              return nil if ret == equiv_nil
              ret
            end
          end

          # scale an integer by dividing it by a denominator.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param denominator [Integer] The divisor to use in scaling down the result
          # @param equiv_nil [Integer] If applicable, the value for this field that would indicate nil
          # @return [Integer] an integer value
          def _6b_integer_scaled(start, length, denominator, equiv_nil = nil)
            ret = _6b_integer(start, length, equiv_nil)
            return nil if ret.nil?
            ret.to_f / denominator
          end

          # scale an unsigned integer by dividing it by a denominator.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param denominator [Integer] The divisor to use in scaling down the result
          # @param equiv_nil [Integer] If applicable, the value for this field that would indicate nil
          # @return [Integer] an integer value
          def _6b_unsigned_integer_scaled(start, length, denominator, equiv_nil = nil)
            ret = _6b_unsigned_integer(start, length, equiv_nil)
            return nil if ret.nil?
            ret.to_f / denominator
          end

          # scale an integer by dividing it by a denominator.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param denominator [Integer] The divisor to use in scaling down the result
          # @param shift [Float] the amount to shift (up) the result by
          # @param equiv_nil [Integer] If applicable, the value for this field that would indicate nil
          # @return [Integer] an integer value
          def _6b_integer_scaled_shifted(start, length, denominator, shift, equiv_nil = nil)
            ret = _6b_integer_scaled(start, length, denominator, equiv_nil)
            return nil if ret.nil?
            ret + shift
          end

          # scale an unsigned integer by dividing it by a denominator.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param denominator [Integer] The divisor to use in scaling down the result
          # @param shift [Float] the amount to shift (up) the result by
          # @param equiv_nil [Integer] If applicable, the value for this field that would indicate nil
          # @return [Integer] an integer value
          def _6b_unsigned_integer_scaled_shifted(start, length, denominator, shift, equiv_nil = nil)
            ret = _6b_unsigned_integer_scaled(start, length, denominator, equiv_nil)
            return nil if ret.nil?
            ret + shift
          end

          # Get the value of a bit in the payload.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param _ [Integer] Doesn't matter.  Here so signatures match; we hard-code 1 because it's 1 bit.
          # @return [bool]
          def _6b_boolean(start, _)
            _access(start, 1) { |bits| bits.to_i == 1 }
          end

          # Get the flipped value of a bit in the payload.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param _ [Integer] Doesn't matter.  Here so signatures match; we hard-code 1 because it's 1 bit.
          # @return [bool]
          def _6b_negated_boolean(start, _)
            !_6b_boolean(start, 1)
          end

          # Return a string representing binary digits.
          # This function is meant to be passed as a formatter to {payload_reader}.
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @return [String] e.g. "0101010101011000"
          def _2b_data_string(start, length)
            _access(start, length)
          end

          # use shorthand for data types as defined in http://catb.org/gpsd/AIVDM.html
          alias _u  _6b_unsigned_integer
          alias _U  _6b_unsigned_integer_scaled
          alias _i  _6b_integer
          alias _I  _6b_integer_scaled
          alias _b  _6b_boolean
          alias _nb _6b_negated_boolean
          alias _e  _6b_unsigned_integer
          alias _t  _6b_string_nullterminated
          alias _tt _6b_string
          alias _T  _8b_data_string
          alias _d  _2b_data_string
          alias _UU _6b_unsigned_integer_scaled_shifted
          alias _II _6b_integer_scaled_shifted

          # Get the date value of a month/day/hour/minute package
          # This function is meant to be used for commonly-found date operations
          # in which year, seconds, and timezone are not specified.
          # @param month [Integer] the month number, 1-indexed, optional
          # @param day [Integer] the day number, 1-indexed
          # @param hour [Integer] the hour number, 0-indexed
          # @param minute [Integer] the minute number, 0-indexed
          def _get_date_mdhm(month, day, hour, minute)
            now = Time.now
            month = now.month if month.nil?

            return nil if month.zero?
            return nil if day.zero?
            return nil if hour == 24
            return nil if minute == 60

            # try to be smart about picking a year
            rollover = 0
            rollover = 1 if now.month > month
            rollover = -1 if now.month == 1 && month == 12
            Time.new(now.year + rollover, month, day, hour, minute, 0, '+00:00')
          end

        end
      end
    end
  end
end
