require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # ZDA - Time & Date - UTC, day, month, year and local time zone
      class ZDA < NMEAPlus::Message::NMEA::NMEAMessage

        # UTC Time
        # @!parse attr_reader :utc_time
        # @return [Time]
        def utc_time
          re_format = /(\d{2})(\d{2})(\d{2}(\.\d+)?)/
          hms = re_format.match(@fields[1])
          begin
            tz_h = @fields[5].to_i
            tz = format("%<sign>s%02<hour>d:%02<minute>d", sign: tz_h >= 0 ? "+" : "-", hour: tz_h.abs, minute: @fields[6].to_i)
            Time.new(@fields[4].to_i, @fields[3].to_i, @fields[2].to_i,
                     hms[1].to_i, hms[2].to_i, hms[3].to_f, tz)
          rescue ArgumentError
            # Assume invalid fields.
            # TODO: handle this better, last time I got tripped up with %02d and minus sign chars
            nil
          end
        end
      end
    end
  end
end
