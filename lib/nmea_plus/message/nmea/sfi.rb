require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SFI - Scanning Frequency Information
      class SFI < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :total_messages, 1, :_integer
        field_reader :message_number, 2, :_integer

        # returns pairs of frequency, mode
        # @!parse attr_reader :frequencies
        # @return [Array<Float>]
        def frequencies
          @fields[3..-1].each_slice(2).to_a.map { |x| [x[0].to_f, x[1]] }
        end

      end
    end
  end
end
