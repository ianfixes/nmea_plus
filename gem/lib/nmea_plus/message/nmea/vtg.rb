require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class VTG < NMEAPlus::Message::NMEA::NMEAMessage
        # whether this is the new format.  docs say check field #2 for value "2"
        def new_format?
          'T' == @fields[2]
        end

        field_reader :track_degrees_true, 1, :_float

        def track_degrees_magnetic
          f = new_format? ? 3 : 2
          return nil if @fields[f].nil? or @fields[f].empty?
          @fields[f].to_f
        end

        def speed_knots
          f = new_format? ? 5 : 3
          return nil if @fields[f].nil? or @fields[f].empty?
          @fields[f].to_f
        end

        def speed_kmh
          f = new_format? ? 7 : 4
          return nil if @fields[f].nil? or @fields[f].empty?
          @fields[f].to_f
        end

        def faa_mode
          f = new_format? ? 9 : 100
          return nil if @fields[f].nil? or @fields[f].empty?
          @fields[f]
        end

      end
    end
  end
end
