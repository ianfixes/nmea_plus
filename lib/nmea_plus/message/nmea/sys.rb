require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SYS - Hybrid System Configuration
      # Limited utility, no recommended replacement
      class SYS < NMEAPlus::Message::NMEA::NMEAMessage

        # Systems in use
        # @!parse attr_reader :systems
        # @return [Array<Symbol>]
        def systems
          abbr = {
            "L" => :loran_c,
            "O" => :omega,
            "T" => :transit,
            "G" => :gps,
            "D" => :decca
          }

          # drop blank fields and convert to symbol
          @fields[1..5].reject(&:empty?).map { |x| abbr[x] }
        end

      end
    end
  end
end
