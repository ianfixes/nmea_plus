require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # IMA - Vessel Identification
      class IMA < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :vessel_name, 1, :_string
        field_reader :call_sign, 2, :_string

        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          self.class.degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          self.class.degrees_minutes_to_decimal(@fields[5], @fields[6])
        end

        field_reader :true_heading_degrees, 7, :_float
        field_reader :magnetic_heading_degrees, 9, :_float
        field_reader :speed_knots, 11, :_float
      end
    end
  end
end
