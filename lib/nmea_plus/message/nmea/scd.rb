require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # SCD - Loran-C ECDs (Envelope Cycle Discrepancies)
      # The use of $--LCD is recommended.
      # @see LCD
      class SCD < NMEAPlus::Message::NMEA::NMEAMessage
        # Master signal ECD
        field_reader :master_signal_ecd, 2, :_integer

        # All ECDs
        # @!parse attr_reader :ecds
        # @return [Array<Integer>]
        def ecds
          (0..5).to_a.map { |x| (2 * x) + 2 }.map { |i| @fields[i].to_i }
        end
      end
    end
  end
end
