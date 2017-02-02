require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SGR - Loran-C Chain Identifier
      class SGR < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :chain_identifier, 1, :_integer

        # @!parse attr_reader :gri_microseconds
        # @return [Integer]
        def gri_microseconds
          return nil if chain_identifier.nil?
          chain_identifier * 10
        end
      end
    end
  end
end
