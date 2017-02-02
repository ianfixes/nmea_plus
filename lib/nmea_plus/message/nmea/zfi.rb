require_relative "zaa"

module NMEAPlus
  module Message
    module NMEA
      # ZFI - Elapsed time from point-of-interest
      class ZFI < NMEAPlus::Message::NMEA::ZAA
        field_reader :elapsed_time, 2, :_interval_hms
      end
    end
  end
end
