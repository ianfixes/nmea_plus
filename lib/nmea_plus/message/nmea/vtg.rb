require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class VTG < NMEAPlus::Message::NMEA::NMEAMessage
        # whether this is the new format.  docs say check field #2 for value "2"
        # @return [bool]
        def new_format?
          'T' == @fields[2]
        end

        field_reader :track_degrees_true, 1, :_float

        # @!parse attr_reader :track_degrees_magnetic
        # @return [Float]
        def track_degrees_magnetic
          f = new_format? ? 3 : 2
          return nil if @fields[f].nil? || @fields[f].empty?
          @fields[f].to_f
        end

        # @!parse attr_reader :speed_knots
        # @return [Float]
        def speed_knots
          f = new_format? ? 5 : 3
          return nil if @fields[f].nil? || @fields[f].empty?
          @fields[f].to_f
        end

        # @!parse attr_reader :speed_kmh
        # @return [Float]
        def speed_kmh
          f = new_format? ? 7 : 4
          return nil if @fields[f].nil? || @fields[f].empty?
          @fields[f].to_f
        end

        # @!parse attr_reader :faa_mode
        # @return [String]
        def faa_mode
          f = new_format? ? 9 : 100
          return nil if @fields[f].nil? || @fields[f].empty?
          @fields[f]
        end

      end
    end
  end
end
