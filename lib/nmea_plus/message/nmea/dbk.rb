require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # DBK - Depth Below Keel
      #
      # Water depth referenced to the vessel's keel
      # The use of $--DPT is recommended
      # @see DPT
      class DBK < NMEAPlus::Message::NMEA::NMEAMessage
        # Water depth, feet
        field_reader :depth_feet, 1, :_float

        # Water depth, Meters
        field_reader :depth_meters, 3, :_float

        # Water depth, Fathoms
        field_reader :depth_fathoms, 5, :_float
      end
    end
  end
end
