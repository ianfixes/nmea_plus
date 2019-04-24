require 'nmea_plus/message/nmea/zzu'

module NMEAPlus
  module Message
    module NMEA
      # ZLZ - Time of Day
      # Time of day in hours-minutes-seconds, both with respect to (UTC) and the local time zone.
      # The use of $--ZDA is recommended
      # @see ZDA
      class ZLZ < NMEAPlus::Message::NMEA::ZZU
        # Local time
        field_reader :local_time, 2, :_utctime_hms

        # Local zone description, 00 to 12
        field_reader :zone_description, 3, :_integer
      end
    end
  end
end
