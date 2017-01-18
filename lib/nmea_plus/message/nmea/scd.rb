require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SCD - Loran-C ECDs (Envelope Cycle Discrepancies)
      class SCD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :master_signal_ecd, 2, :_integer

        # @!parse attr_reader :ecds
        # @return [Array<Integer>]
        def ecds
          (0..5).to_a.map { |x| 2 * x + 2 } .map { |i| @fields[i].to_i }
        end
      end
    end
  end
end
