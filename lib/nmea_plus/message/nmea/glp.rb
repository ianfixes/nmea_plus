require 'nmea_plus/message/nmea/gda'

module NMEAPlus
  module Message
    module NMEA
      # GLP - Loran-C Determined Positions
      #
      # The use of waypoint location $--WPL (for past positions) or $--GLL (for present position) followed by time tag $--ZDA
      # is recommended for reporting past or present waypoint times; $--WPL followed by $--ZTG is recommended for
      # estimated time.
      # @see WPL
      # @see GLL
      # @see ZDA
      # @see ZTG
      class GLP < NMEAPlus::Message::NMEA::GDA
      end
    end
  end
end
