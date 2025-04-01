require "nmea_plus/message/nmea/base_nmea"
require "nmea_plus/message/nmea/dbk"

module NMEAPlus
  module Message
    module NMEA
      # DBT - Depth below transducer
      class DBT < NMEAPlus::Message::NMEA::DBK
      end
    end
  end
end
