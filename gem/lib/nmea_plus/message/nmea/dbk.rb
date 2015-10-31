require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class DBK < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :depth_feet, 1, :_float
        field_reader :depth_meters, 3, :_float
        field_reader :depth_fathoms, 5, :_float
      end
    end
  end
end
