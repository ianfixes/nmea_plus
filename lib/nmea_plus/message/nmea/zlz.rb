require_relative "zzu"

module NMEAPlus
  module Message
    module NMEA
      # ZLZ - Time of Day
      class ZLZ < NMEAPlus::Message::NMEA::ZZU
        field_reader :local_time, 2, :_utctime_hms
        field_reader :zone_description, 3, :_integer
      end
    end
  end
end
