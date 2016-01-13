
module NMEAPlus

  # This module contains all parsed NMEA message types, and their subtypes.
  # @see NMEAPlus::Message::Base Base class for all NMEA-style messages
  module Message

    # The base NMEA message type, from which all others inherit.  Messages have a prefix character,
    # fields, and checksum.  This class provides convenience functions for accessing the fields as
    # the appropriate data type, and logic for constructing multipart messages.
    # @abstract
    class Base
      # Enable a shortcut syntax for message attribute accessors, in the style of `attr_accessor` metaprogramming.
      # This is used to create a named field pointing to a specific indexed field in the payload, optionally applying
      # a specific formatting function.
      # @param name [String] What the accessor will be called
      # @param field_num [Integer] The index of the field in the payload
      # @param formatter [Symbol] The symbol for the formatting function to apply to the field (optional)
      # @return [void]
      # @macro [attach] field_reader
      #   @!attribute [r] $1
      #   @return field $2 of the payload, formatted with the function {#$3}
      def self.field_reader(name, field_num, formatter = nil)
        if formatter.nil?
          self.class_eval("def #{name};@fields[#{field_num}];end")
        else
          self.class_eval("def #{name};#{formatter}(@fields[#{field_num}]);end")
        end
      end

      # @return [String] The single character prefix for this NMEA 0183 message type
      attr_accessor :prefix

      # @return [String] The unprocessed payload of the message
      attr_reader :payload

      # @return [Array<String>] The payload of the message, split into fields
      attr_reader :fields

      # @return [String] The two-character checksum of the message
      attr_accessor :checksum

      # @return [String] The data type used by the {MessageFactory} to parse this message
      attr_accessor :interpreted_data_type

      # @return [NMEAPlus::Message] The next part of a multipart message, if available
      attr_accessor :next_part

      # @return [String] The NMEA data type of this message
      field_reader :data_type, 0, nil

      # @!parse attr_reader :original
      # @return [String] The original message
      def original
        "#{prefix}#{payload}*#{checksum}"
      end

      # @!parse attr_accessor :payload
      def payload=(val)
        @payload = val
        @fields = val.split(',', -1)
      end

      # @return [bool] Whether the checksum calculated from the payload matches the checksum given in the message
      def checksum_ok?
        calculated_checksum.upcase == checksum.upcase
      end

      # return [bool] Whether the checksums for all available message parts are OK
      def all_checksums_ok?
        return false unless checksum_ok?
        return true if @next_part.nil?
        @next_part.all_checksums_ok?
      end

      # return [String] The calculated checksum for this payload as a two-character string
      def calculated_checksum
        "%02x" % @payload.each_byte.map(&:ord).reduce(:^)
      end

      # @!parse attr_reader :total_messages
      # @abstract
      # @see #message_number
      # @return [Integer] The number of parts to this message
      def total_messages
        1
      end

      # @!parse attr_reader :message_number
      # @abstract
      # @see #total_messages
      # @return [Integer] The ordinal number of this message in its sequence
      def message_number
        1
      end

      # Create a linked list of messages by appending a new message to the end of the chain that starts
      # with this message.  (O(n) implementation; message parts assumed to be < 10)
      # @param msg [NMEAPlus::Message] The latest message in the chain
      # @return [void]
      def add_message_part(msg)
        if @next_part.nil?
          @next_part = msg
        else
          @next_part.add_message_part(msg)
        end
      end

      # @return [bool] Whether all messages in a multipart message have been received.
      def all_messages_received?
        total_messages == highest_contiguous_index
      end

      # @return [Integer] The highest contiguous sequence number of linked message parts
      # @see #message_number
      # @see #_highest_contiguous_index
      def highest_contiguous_index
        _highest_contiguous_index(0)
      end

      # Helper function to calculate the contiguous index
      # @param last_index [Integer] the index of the starting message
      # @see #highest_contiguous_index
      # @return [Integer] The highest contiguous sequence number of linked message parts
      def _highest_contiguous_index(last_index)
        mn = message_number # just in case this is expensive to compute
        return last_index if mn - last_index != 1      # indicating a skip or restart
        return mn if @next_part.nil?                   # indicating we're the last message
        @next_part._highest_contiguous_index(mn)       # recurse down
      end

      ######################### Conversion functions

      # Convert A string latitude or longitude as fields into a signed number
      # @param dm_string [String] An angular measurement in the form DDMM.MMM
      # @param sign_letter [String] can be N,S,E,W
      # @return [Float] A signed latitude or longitude
      def self.degrees_minutes_to_decimal(dm_string, sign_letter = "")
        return nil if dm_string.nil? || dm_string.empty?
        r = /(\d+)(\d{2}\.\d+)/  # (some number of digits) (2 digits for minutes).(decimal minutes)
        m = r.match(dm_string)
        raw = m.values_at(1)[0].to_f + (m.values_at(2)[0].to_f / 60)
        nsew_signed_float(raw, sign_letter)
      end

      # Use cardinal directions to assign positive or negative to mixed_val
      # Of possible directions NSEW (sign_letter) treat N/E as + and S/W as -
      # @param mixed_val [String] input value, can be string or float
      # @param sign_letter [String] can be N,S,E,W, or empty
      # @return [Float] The input value signed as per the sign letter.
      def self.nsew_signed_float(mixed_val, sign_letter = "")
        value = mixed_val.to_f
        value *= -1 if !sign_letter.empty? && "SW".include?(sign_letter.upcase)
        value
      end

      # integer or nil.
      # This function is meant to be passed as a formatter to {field_reader}.
      # @param field [String] the value in the field to be checked
      # @return [Integer] The value in the field or nil
      def _integer(field)
        return nil if field.nil? || field.empty?
        field.to_i
      end

      # float or nil.
      # This function is meant to be passed as a formatter to {field_reader}.
      # @param field [String] the value in the field to be checked
      # @return [Float] The value in the field or nil
      def _float(field)
        return nil if field.nil? || field.empty?
        field.to_f
      end

      # string or nil.
      # This function is meant to be passed as a formatter to {field_reader}.
      # @param field [String] the value in the field to be checked
      # @return [String] The value in the field or nil
      def _string(field)
        return nil if field.nil? || field.empty?
        field
      end

      # hex to int or nil.
      # This function is meant to be passed as a formatter to {field_reader}.
      # @param field [String] the value in the field to be checked
      # @return [Integer] The value in the field or nil
      def _hex_to_integer(field)
        return nil if field.nil? || field.empty?
        field.hex
      end

      # utc time or nil (HHMMSS or HHMMSS.SS).
      # This function is meant to be passed as a formatter to {field_reader}.
      # @param field [String] the value in the field to be checked
      # @return [Time] The value in the field or nil
      def _utctime_hms(field)
        return nil if field.nil? || field.empty?
        re_format = /(\d{2})(\d{2})(\d{2}(\.\d+)?)/
        now = Time.now
        begin
          hms = re_format.match(field)
          Time.new(now.year, now.month, now.day, hms[1].to_i, hms[2].to_i, hms[3].to_f)
        rescue
          nil
        end
      end

      # time interval or nil (HHMMSS or HHMMSS.SS).
      # This function is meant to be passed as a formatter to {field_reader}.
      # @param field [String] the value in the field to be checked
      # @return [Time] The value in the field or nil
      def _interval_hms(field)
        return nil if field.nil? || field.empty?
        re_format = /(\d{2})(\d{2})(\d{2}(\.\d+)?)/
        begin
          hms = re_format.match(field)
          Time.new(0, 0, 0, hms[1].to_i, hms[2].to_i, hms[3].to_f)
        rescue
          nil
        end
      end

      # Create a Time object from a date and time field
      # @param d_field [String] the date value in the field to be checked
      # @param t_field [String] the time value in the field to be checked
      # @return [Time] The value in the fields, or nil if either is not provided
      def _utc_date_time(d_field, t_field)
        return nil if t_field.nil? || t_field.empty?
        return nil if d_field.nil? || d_field.empty?

        # get formats and time
        time_format = /(\d{2})(\d{2})(\d{2}(\.\d+)?)/
        date_format = /(\d{2})(\d{2})(\d{2})/

        # crunch numbers
        begin
          dmy = date_format.match(d_field)
          hms = time_format.match(t_field)
          Time.new(2000 + dmy[3].to_i, dmy[2].to_i, dmy[1].to_i, hms[1].to_i, hms[2].to_i, hms[3].to_f)
        rescue
          nil
        end
      end

    end
  end
end
