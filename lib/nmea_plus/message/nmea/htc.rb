require_relative "hdt"

module NMEAPlus
  module Message
    module NMEA
      # HTC - Heading, True
      # Actual vessel heading in degrees True produced by any device or system producing true heading
      class HTC < NMEAPlus::Message::NMEA::HDT; end
    end
  end
end
