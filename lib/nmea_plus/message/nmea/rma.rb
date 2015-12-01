require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class RMA < NMEAPlus::Message::NMEA::NMEAMessage

        field_reader :blink_warning, 1, :_av_boolean

        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          _degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          _degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        field_reader :time_difference_a, 6, :_float
        field_reader :time_difference_b, 7, :_float
        field_reader :speed_over_ground_knots, 8, :_float
        field_reader :track_made_good_degrees_true, 9, :_float

        # @!parse attr_reader :magnetic_variation_degrees
        # @return [Float]
        def magnetic_variation_degrees
          _nsew_signed_float(@fields[10], @fields[11])
        end

      end
    end
  end
end
