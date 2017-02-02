require_relative "zaa"

module NMEAPlus
  module Message
    module NMEA
      # ZTE - Estimated time to event
      class ZTE < NMEAPlus::Message::NMEA::ZAA
        field_reader :estimated_remaining_time, 2, :_interval_hms
      end
    end
  end
end
