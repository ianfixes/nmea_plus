require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # ZZU - Time, UTC
      class ZZU < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :utc_time, 1, :_utctime_hms
      end
    end
  end
end
