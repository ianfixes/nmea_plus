require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # HCC - Compass Heading
      # Vessel compass heading, which differs from magnetic heading by the amount of uncorrected magnetic deviation.
      #
      # The use of $--HDG is recommended.
      # @see HCC
      class HCC < NMEAPlus::Message::NMEA::NMEAMessage
        # Compass heading, degrees
        field_reader :compass_heading_degrees, 1, :_float
      end
    end
  end
end
