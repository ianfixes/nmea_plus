require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # GDA - Dead Reckoning Positions
      class GDA < NMEAPlus::Message::NMEA::NMEAMessage

        field_reader :fix_time, 1, :_utctime_hms

        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          self.class.degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          self.class.degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        field_reader :waypoint_id, 6, :_integer
      end
    end
  end
end
