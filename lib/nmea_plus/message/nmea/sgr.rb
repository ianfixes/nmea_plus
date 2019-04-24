require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # SGR - Loran-C Chain Identifier
      # The unique Loran-C Chain identifier, representing Group Repetition Interval (GRI)
      class SGR < NMEAPlus::Message::NMEA::NMEAMessage
        # Chain ID, representing tens of microseconds
        field_reader :chain_identifier, 1, :_integer

        # GRI, microseconds.
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
