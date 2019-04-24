require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # MWS - Wind & Sea State
      #
      # Limited utility, no recommended replacement.
      class MWS < NMEAPlus::Message::NMEA::NMEAMessage
        # Beaufort Wind Force Code
        field_reader :beaufort_wind_force, 1, :_integer

        # Beaufort Sea State Code
        field_reader :beaufort_sea_state, 2, :_integer
      end
    end
  end
end
