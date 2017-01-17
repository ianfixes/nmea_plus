require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SCY - Loran-C Cycle Lock Status
      class SCY < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :cycle_lock_flag?, 1, :_av_boolean
      end
    end
  end
end
