require_relative "hvd"

module NMEAPlus
  module Message
    module NMEA
      # HVM - Magnetic Variation, Manually Set
      #
      # Magnetic variation, manually entered
      #
      # The use of $--HDG is recommended.
      # @see HDG
      class HVM < NMEAPlus::Message::NMEA::HVD; end
    end
  end
end
