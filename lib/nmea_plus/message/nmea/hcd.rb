require "nmea_plus/message/nmea/hdm"

module NMEAPlus
  module Message
    module NMEA
      # HCD - Heading and Deviation
      # Actual vessel magnetic heading, indicated compass heading and the difference (deviation) between them.
      #
      # Easterly deviation (E) subtracts from Compass Heading
      # Westerly deviation (W) adds to Compass Heading
      #
      # The use of $--HDG is recommended.
      # @see HDG
      class HCD < NMEAPlus::Message::NMEA::HDM
        # Compass heading, degrees
        field_reader :compass_heading_degrees, 3, :_float

        # Magnetic deviation, degrees E/W
        # @!parse attr_reader :magnetic_deviation_degrees
        # @return [Float]
        def magnetic_deviation_degrees
          self.class.nsew_signed_float(@fields[5], @fields[6])
        end

      end
    end
  end
end
