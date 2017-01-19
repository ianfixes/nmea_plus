require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SGR - Loran-C Chain Identifier
      class SGR < NMEAPlus::Message::NMEA::NMEAMessage
        # @!parse attr_reader :gri_microseconds
        # @return [Integer]
        def gri_microseconds
          field = @fields[1]
          return nil if field.nil? || field.empty?
          field.to_i * 10
        end
      end
    end
  end
end
