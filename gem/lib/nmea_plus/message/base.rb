
module NMEAPlus
 module Message
   class Base
     attr_accessor :prefix
     attr_reader :payload
     attr_reader :fields
     attr_accessor :checksum
     attr_accessor :interpreted_data_type

     def original
       "#{prefix}#{payload}*#{checksum}"
     end

     def payload= val
       @payload = val
       @fields = val.split(',', -1)
     end

     def data_type
       @fields[0]
     end

     def checksum_ok?
       calculated_checksum == checksum
     end

     def calculated_checksum
       "%02x" % payload.each_byte.map{|b| b.ord}.reduce(:^)
     end

     # conversion functions

     # convert DDMM.MMM to single decimal value.
     # sign_letter can be N,S,E,W
     def _degrees_minutes_to_decimal(dm_string, sign_letter = "")
       return nil if dm_string.empty?
       r = /(\d+)(\d{2}\.\d+)/  # (some number of digits) (2 digits for minutes).(decimal minutes)
       m = r.match(dm_string)
       raw = m.values_at(1)[0].to_f + (m.values_at(2)[0].to_f / 60)
       raw *= -1 if !sign_letter.empty? and "SW".include? sign_letter.upcase
       raw
     end

     # integer or nil
     def _integer(field)
       return nil if field.empty?
       field.to_i
     end

     # float or nil
     def _float(field)
       return nil if field.empty?
       field.to_f
     end

     # string or nil
     def _string(field)
       return nil if field.empty?
       field
     end

     # hex to int or nil
     def _hex_to_integer(field)
       return nil if field.empty?
       field.hex
     end

     # utc time or nil (HHMMSS)
     def _utctime_hms(field)
       return nil if field.empty?
       now = Time.now
       hms = field.scan(/../).map { |t| t.to_i }
       Time.new(now.year, now.month, now.day, hms[0], hms[1], hms[2])
     end

   end
 end
end
