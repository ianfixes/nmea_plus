
class Class
  # make our own shortcut syntax for message attributes
  def field_reader(name, field_num, formatter = nil)
    if formatter.nil?
      self.class_eval("def #{name};@fields[#{field_num}];end")
    else
      self.class_eval("def #{name};#{formatter}(@fields[#{field_num}]);end")
    end
  end
end

module NMEAPlus
  module Message
    class Base
      attr_accessor :prefix
      attr_reader :payload
      attr_reader :fields
      attr_accessor :checksum
      attr_accessor :interpreted_data_type
      attr_accessor :next_part

      field_reader :data_type, 0, nil

      def original
        "#{prefix}#{payload}*#{checksum}"
      end

      def payload=(val)
        @payload = val
        @fields = val.split(',', -1)
      end

      def checksum_ok?
        calculated_checksum.upcase == checksum.upcase
      end

      def all_checksums_ok?
        return false if !checksum_ok?
        return true if @next_part.nil?
        return @next_part.all_checksums_ok?
      end

      def calculated_checksum
        "%02x" % @payload.each_byte.map(&:ord).reduce(:^)
      end

      # many messages override these fields
      def total_messages
        1
      end

      # sequence number
      def message_number
        1
      end

      # create a linked list (O(n) implementation; message parts assumed to be < 10) of message parts
      def add_message_part(msg)
        if @next_part.nil?
          @next_part = msg
        else
          @next_part.add_message_part(msg)
        end
      end

      def all_messages_received?
        message_number == 1 && _all_message_parts_chained?(0)
      end

      def _all_message_parts_chained?(highest_contiguous_index)
        mn = message_number # just in case this is expensive to compute
        return false if mn - highest_contiguous_index != 1 # indicating a skip or restart
        return true  if mn == total_messages               # indicating we made it to the end
        return false if @next_part.nil?                    # indicating we're incomplete
        @next_part._all_message_parts_chained?(mn)         # recurse down
      end

      # conversion functions

      # convert DDMM.MMM to single decimal value.
      # sign_letter can be N,S,E,W
      def _degrees_minutes_to_decimal(dm_string, sign_letter = "")
        return nil if dm_string.nil? || dm_string.empty?
        r = /(\d+)(\d{2}\.\d+)/  # (some number of digits) (2 digits for minutes).(decimal minutes)
        m = r.match(dm_string)
        raw = m.values_at(1)[0].to_f + (m.values_at(2)[0].to_f / 60)
        _nsew_signed_float(raw, sign_letter)
      end

      # Use cardinal directions to assign positive or negative to mixed_val
      # mixed_val can be string or float
      # Of possible directions NSEW (sign_letter) treat N/E as + and S/W as -
      def _nsew_signed_float(mixed_val, sign_letter = "")
        value = mixed_val.to_f
        value *= -1 if !sign_letter.empty? && "SW".include?(sign_letter.upcase)
        value
      end

      # integer or nil
      def _integer(field)
        return nil if field.nil? || field.empty?
        field.to_i
      end

      # float or nil
      def _float(field)
        return nil if field.nil? || field.empty?
        field.to_f
      end

      # string or nil
      def _string(field)
        return nil if field.nil? || field.empty?
        field
      end

      # hex to int or nil
      def _hex_to_integer(field)
        return nil if field.nil? || field.empty?
        field.hex
      end

      # utc time or nil (HHMMSS or HHMMSS.SS)
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

      # time interval or nil (HHMMSS or HHMMSS.SS)
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
