require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # HDM - Heading - Magnetic
      # Actual vessel heading in degrees Magnetic.
      #
      # The use of $--HDG is recommended.
      # @see HDG
      class HDM < NMEAPlus::Message::NMEA::NMEAMessage
        # Magnetic heading, degrees
        field_reader :magnetic_heading_degrees, 1, :_float
      end
    end
  end
end
