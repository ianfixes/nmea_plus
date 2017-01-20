require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # SIU - Loran-C Stations in Use
      class SIU < NMEAPlus::Message::NMEA::NMEAMessage
        # Array of flags for stations in use, indexed by station number
        # @!parse attr_reader :stations_in_use
        # @return [Array<Boolean>]
        def stations_in_use
          # dummy index 0, empty fields indicate stations not in use
          [false] + (1..8).to_a.map { |x| !(@fields[x].nil? || @fields[x].empty?) }
        end
      end
    end
  end
end
