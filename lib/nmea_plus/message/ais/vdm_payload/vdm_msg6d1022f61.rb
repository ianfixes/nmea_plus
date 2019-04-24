require 'nmea_plus/message/ais/vdm_payload/vdm_msg6_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Type 6: Binary Addressed Message Subtype: Sealite SL125 Lantern or 155 Apollo Lantern
        # This message has an ascii CSV payload wrapped in an armored AIS payload, wrapped in the NMEA CSV payload.
        class VDMMsg6d1022f61 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload

          def initialize
            super
            @fields = []
          end

          # The raw payload: comma separated ascii fields
          # @return [String]
          payload_reader :application_data, 88, 384, :_T   # not actually sure if 384 is enough length

          # Override default bitstring setting to automatically load up a fields array for easier access
          def payload_bitstring=(val)
            super
            @fields = application_data.split(",")
          end

          # Return a bit from the 8 bits in field 0
          # @param position [Integer] the bit position: 0=MSB, 7=LSB
          # @return [bool]
          def _field0_bit(position)
            return nil if @fields[1].nil?
            mask = 1 << (7 - position)
            @fields[0].hex & mask == mask
          end

          # Enable a shortcut syntax for bit field attributes, in the style of `attr_accessor` metaprogramming.
          # This is used to create a named field pointing to a specific bit in the first field of the payload
          # @param name [String] What the accessor will be called
          # @param position [Integer] The bit position in this field
          # @return [void]
          # @macro [attach] bit_reader
          #   @!attribute [r] $1
          #   @return [bool] The value in bit $2 of the status field
          def self.bit_reader(name, position)
            define_method(name) { self.send(:_field0_bit, position) }
          end

          bit_reader :supply_fail?, 0
          bit_reader :gps_off_station?, 1
          bit_reader :light_sensor_dark?, 2
          bit_reader :gps_sync_valid?, 3
          bit_reader :gps_valid?, 4
          bit_reader :temperature_sensor_hot?, 5
          bit_reader :battery_flat?, 6
          bit_reader :battery_low?, 7

          # Operation mode (integer code)
          # @!parse attr_reader :operation_mode
          # @return [Integer]
          def operation_mode
            return nil if @fields[1].nil?
            @fields[1].hex >> 6
          end

          # A human-readable description of the operation mode
          # @!parse attr_reader :operation_mode_description
          # @return [String]
          def operation_mode_description
            case operation_mode
            when 1 then "Standby"
            when 2 then "Always on"
            else
              "description n/a" # TODO
            end
          end

          # This field seems to be a 0-100% value encoded as 6-bit.
          # The test cases seem to indicate that it is offset by +1.5625, which may mean that "3F" is a special case.
          # But I have no data on that.
          # @!parse attr_reader :intensity_percent
          # @return [Float]
          def intensity_percent
            return nil if @fields[1].nil?
            (1 + (@fields[1].hex & "3F".hex)) * (100.0 / 2**6)
          end

          # A vendor-specific code
          # @!parse attr_reader :flash_code
          # @return [String]
          def flash_code
            @fields[2].nil? ? nil : @fields[2].hex
          end

          # The battery voltage in volts
          # @!parse attr_reader :battery_voltage
          # @return [Float]
          def battery_voltage
            @fields[3].nil? ? nil : @fields[3].to_f
          end

          # Latitude
          # @!parse attr_reader :latitude
          # @return [Float]
          def latitude
            parts = @fields[4]
            return nil if parts.nil?
            NMEAPlus::Message::Base.degrees_minutes_to_decimal(parts[0..-1], parts[-1])
          end

          # Longitude
          # @!parse attr_reader :longitude
          # @return [Float]
          def longitude
            parts = @fields[5]
            return nil if parts.nil?
            NMEAPlus::Message::Base.degrees_minutes_to_decimal(parts[0..-1], parts[-1])
          end

        end
      end
    end
  end
end
