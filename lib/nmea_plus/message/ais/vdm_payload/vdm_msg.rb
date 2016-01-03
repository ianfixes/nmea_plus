
module NMEAPlus
  module Message
    module AIS
      # There are many VDM payload types, and this is their container.  See {VDMMsg}.
      module VDMPayload
        # The base class for the AIS payload (of {NMEAPlus::Message::AIS::VDM}), which uses its own encoding for its own subtypes
        class VDMMsg

          def initialize; end

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
          def _6b_integer(start, length)
            case @payload_bitstring[start]
            when "0"
              _6b_unsigned_integer(start, length)
            when "1"
              # MSB is 1 for negative
              # two's complement: flip bits, then add 1
              _access(start, length) { |bits| (bits.tr("01", "10").to_i(2) + 1) * -1 }
            end
          end

          # scale an integer by dividing it by 10^decimal_places
          # @param start [Integer] The index of the first bit in the payload field
          # @param length [Integer] The number of bits in the payload field
          # @param decimal_places [Integer] The power of ten to use in scaling down the result
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

          # The ship cargo type description lookup table
          # @param code [Integer] The cargo type id
          # @return [String] Cargo type description
          def get_ship_cargo_type_description(code)
            case code
            when 0 then return nil
            when 1...19 then return "(future use)"
            when 20 then return "WIG (any)"
            when 21 then return "WIG Hazardous category A"
            when 22 then return "WIG Hazardous category B"
            when 23 then return "WIG Hazardous category C"
            when 24 then return "WIG Hazardous category D"
            when 25...29 then return "WIG (future use)"
            when 30 then return "Fishing"
            when 31 then return "Towing"
            when 32 then return "Towing (large)"
            when 33 then return "Dredging/underwater ops"
            when 34 then return "Diving ops"
            when 35 then return "Military ops"
            when 36 then return "Sailing"
            when 37 then return "Pleasure craft"
            when 38, 39 then return "Reserved"
            when 40 then return "High Speed Craft"
            when 41 then return "HSC Hazardous category A"
            when 42 then return "HSC Hazardous category B"
            when 43 then return "HSC Hazardous category C"
            when 44 then return "HSC Hazardous category D"
            when 45...48 then return "HSC (reserved)"
            when 49 then return "HSC (no additional information)"
            when 50 then return "Pilot Vessel"
            when 51 then return "Search and Rescue Vessel"
            when 52 then return "Tug"
            when 53 then return "Port Tender"
            when 54 then return "Anti-pollution equipment"
            when 55 then return "Law Enforcement"
            when 56, 57 then return "Spare - Local Vessel"
            when 58 then return "Medical Transport"
            when 59 then return "Noncombatant ship according to RR Resolution No. 18"
            when 60 then return "Passenger"
            when 61 then return "Passenger, Hazardous category A"
            when 62 then return "Passenger, Hazardous category B"
            when 63 then return "Passenger, Hazardous category C"
            when 64 then return "Passenger, Hazardous category D"
            when 65..68 then return "Passenger, Reserved for future use"
            when 69 then return "Passenger, No additional information"
            when 70 then return "Cargo"
            when 71 then return "Cargo, Hazardous category A"
            when 72 then return "Cargo, Hazardous category B"
            when 73 then return "Cargo, Hazardous category C"
            when 74 then return "Cargo, Hazardous category D"
            when 75..78 then return "Cargo, Reserved for future use"
            when 79 then return "Cargo, No additional information"
            when 80 then return "Tanker"
            when 81 then return "Tanker, Hazardous category A"
            when 82 then return "Tanker, Hazardous category B"
            when 83 then return "Tanker, Hazardous category C"
            when 84 then return "Tanker, Hazardous category D"
            when 85.88 then return "Tanker, Reserved for future use"
            when 89 then return "Tanker, No additional information"
            when 90 then return "Other Type"
            when 91 then return "Other Type, Hazardous category A"
            when 92 then return "Other Type, Hazardous category B"
            when 93 then return "Other Type, Hazardous category C"
            when 94 then return "Other Type, Hazardous category D"
            when 95..98 then return "Other Type, Reserved for future use"
            when 99 then return "Other Type, no additional information"
            end
          end

          # An MMSI is associated with an auxiliary craft when it is of the form 98XXXYYYY
          def auxiliary_craft?
            980_000_000 < source_mmsi && source_mmsi < 990_000_000
          end

        end

        # We haven't defined all the AIS payload types, so this is a catch-all
        class VDMMsgUndefined < VDMMsg; end

      end
    end
  end
end
