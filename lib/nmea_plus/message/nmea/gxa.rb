require "nmea_plus/message/nmea/gda"

module NMEAPlus
  module Message
    module NMEA
      # GXA - TRANSIT Position - Latitude/Longitude
      #
      # Location and time of TRANSIT fix at waypoint "c--c".
      # TRANSIT system is not operational, no recommended replacement.
      #
      # The use of waypoint location $--WPL (for past positions) or $--GLL (for present position) followed by time tag $--ZDA
      # is recommended for reporting past or present waypoint times; $--WPL followed by $--ZTG is recommended for
      # estimated time.
      # @see WPL
      # @see GLL
      # @see ZDA
      # @see ZTG
      class GXA < NMEAPlus::Message::NMEA::GDA
        # Satellite number
        field_reader :satellite, 7, :_integer
      end
    end
  end
end
