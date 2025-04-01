require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # GDA - Dead Reckoning Positions
      #
      # The use of waypoint location $--WPL (for past positions) or $--GLL (for present position) followed by time tag $--ZDA
      # is recommended for reporting past or present waypoint times; $--WPL followed by $--ZTG is recommended for
      # estimated time.
      # @see WPL
      # @see GLL
      # @see ZDA
      # @see ZTG
      class GDA < NMEAPlus::Message::NMEA::NMEAMessage

        # UTC of position fix
        field_reader :fix_time, 1, :_utctime_hms

        # Latitude - N/S
        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          self.class.degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        # Longitude - E/W
        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          self.class.degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        # Waypoint ID
        field_reader :waypoint_id, 6, :_string
      end
    end
  end
end
