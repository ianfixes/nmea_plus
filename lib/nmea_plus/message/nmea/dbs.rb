require "nmea_plus/message/nmea/base_nmea"
require "nmea_plus/message/nmea/dbk"

module NMEAPlus
  module Message
    module NMEA
      # DBS - Depth Below Surface
      #
      # Water depth referenced to the water surface
      # The use of $--DPT is recommended
      # @see DPT
      class DBS < NMEAPlus::Message::NMEA::DBK
      end
    end
  end
end
