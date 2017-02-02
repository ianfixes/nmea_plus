require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # MWS - Wind & Sea State
      class MWS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :beaufort_wind_force, 1, :_integer
        field_reader :beaufort_sea_state, 2, :_integer
      end
    end
  end
end
