require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class MSK < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :frequency, 1, :_integer
        field_reader :frequency_mode, 2, :_string
        field_reader :bitrate, 3, :_integer
        field_reader :bitrate_mode, 4, :_string
        field_reader :mss_frequency, 5, :_integer
      end
    end
  end
end
