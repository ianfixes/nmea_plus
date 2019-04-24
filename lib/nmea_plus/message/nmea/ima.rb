require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # IMA - Vessel Identification
      # Limited utility, no recommended replacement
      class IMA < NMEAPlus::Message::NMEA::NMEAMessage
        # 12 character vessel name
        field_reader :vessel_name, 1, :_string

        # Radio call sign
        field_reader :call_sign, 2, :_string

        # Latitude, N/S
        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          self.class.degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        # Longitude, E/W
        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          self.class.degrees_minutes_to_decimal(@fields[5], @fields[6])
        end

        # Heading, degrees True
        field_reader :true_heading_degrees, 7, :_float

        # Heading, degrees Magnetic
        field_reader :magnetic_heading_degrees, 9, :_float

        # Speed, knots
        field_reader :speed_knots, 11, :_float
      end
    end
  end
end
