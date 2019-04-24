require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # WPL - Waypoint Location
      class WPL < NMEAPlus::Message::NMEA::NMEAMessage
        # Latitude in degrees
        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          self.class.degrees_minutes_to_decimal(@fields[1], @fields[2])
        end

        # Longitude in degrees
        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          self.class.degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        field_reader :name, 5, :_string
      end
    end
  end
end
