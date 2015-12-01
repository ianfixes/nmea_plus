class Class
  # make our own shortcut syntax for payload attributes
  def payload_reader(name, start_bit, length, formatter, formatter_arg = nil)
    if formatter_arg.nil?
      self.class_eval("def #{name};#{formatter}(#{start_bit}, #{length});end")
    else
      self.class_eval("def #{name};#{formatter}(#{start_bit}, #{length}, #{formatter_arg});end")
    end
  end
end

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsg
          attr_accessor :payload_bitstring
          attr_accessor :fill_bits

          payload_reader :message_type, 0, 6, :_u
          payload_reader :repeat_indicator, 6, 2, :_u
          payload_reader :source_mmsi, 8, 30, :_u

          # lookup table for 6-bit ascii
          def _6b_ascii(ord)
            '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_ !"#$%&\'()*+,-./0123456789:;<=>?'[ord]
          end

          # access part of the payload.  if there aren't bytes, there, return nil
          # else execute a block
          def _access(start, length)
            part = @payload_bitstring[start, length]
            return nil if part.nil? || part.empty?
            yield part
          end

          # convert an entire string from the payload
          def _6b_string(start, length)
            # pull out 6b chunks from the string, use their value as a lookup into the ascii array
            _bit_slices(start, length, 6).to_a.map(&:join).map { |x| _6b_ascii(x.to_i(2)) }.join
          end

          def _8b_data_string(start, length)
            _bit_slices(start, length, 8).to_a.map(&:join).map { |x| x.to_i(2).chr }.join
          end

          def _bit_slices(start, length, chunk_size)
            _access(start, length) { |bits| bits.chars.each_slice(chunk_size) }
          end

          # convert a string but trim off the 0s ('@')
          def _6b_string_nullterminated(start, length)
            _6b_string(start, length).split("@", 2)[0]
          end

          # directly convert a string to a binary number as you'd read it
          def _6b_unsigned_integer(start, length)
            _access(start, length) { |bits| bits.to_i(2) }
          end

          # perform a twos complement operation on part of the payload
          def _6b_twoscomplement(start, length)
            # two's complement: flip bits, then add 1
            _access(start, length) { |bits| bits.tr("01", "10").to_i(2) + 1 }
          end

          def _6b_integer(start, length)
            # MSB is 1 for negative
            twoc = _6b_twoscomplement(start, length)
            twoc && twoc * (@payload_bitstring[start] == 0 ? 1 : -1)
          end

          # scale an integer by dividing it by 10^decimal_places
          def _6b_integer_scaled(start, length, decimal_places)
            _6b_integer(start, length).to_f / (10 ** decimal_places)
          end

          # scale an unsigned integer by dividing it by 10^decimal_places
          def _6b_unsigned_integer_scaled(start, length, decimal_places)
            _6b_unsigned_integer(start, length).to_f / (10.0 ** decimal_places)
          end

          def _6b_boolean(start, _)
            _access(start, 1) { |bits| bits.to_i == 1 }
          end

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

        class VDMMsgUndefined < VDMMsg; end

      end
    end
  end
end
