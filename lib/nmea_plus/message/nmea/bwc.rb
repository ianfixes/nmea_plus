require_relative "base_nmea"
require_relative "bwr"

module NMEAPlus
  module Message
    module NMEA
      class BWC < NMEAPlus::Message::NMEA::BWR
        field_reader :faa_mode, 13, :_string
      end
    end
  end
end
