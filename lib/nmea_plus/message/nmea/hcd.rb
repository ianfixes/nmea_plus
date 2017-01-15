require_relative "hdm"

module NMEAPlus
  module Message
    module NMEA
      # HCD - Heading and Deviation
      class HCD < NMEAPlus::Message::NMEA::HDM

        field_reader :compass_heading_degrees, 3, :_float

        # @!parse attr_reader :magnetic_deviation_degrees
        # @return [Float]
        def magnetic_deviation_degrees
          self.class.nsew_signed_float(@fields[5], @fields[6])
        end

      end
    end
  end
end
