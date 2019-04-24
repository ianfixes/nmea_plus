require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # ZZU - Time, UTC
      # The use of $--ZDA is recommended
      # @see ZDA
      class ZZU < NMEAPlus::Message::NMEA::NMEAMessage
        # UTC Time
        field_reader :utc_time, 1, :_utctime_hms
      end
    end
  end
end
