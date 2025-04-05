require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # RMC - Recommended Minimum Navigation Information
      class RMC < NMEAPlus::Message::NMEA::NMEAMessage

        # UTC time
        # @!parse attr_reader :utc_time
        # @return [Time]
        def utc_time
          self.class._utc_date_time(@fields[9], @fields[1])
        end

        field_reader :active?, 2, :_av_boolean

        # Latitude in degrees
        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          self.class.degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        # Longitude in degrees
        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          self.class.degrees_minutes_to_decimal(@fields[5], @fields[6])
        end

        field_reader :speed_over_ground_knots, 7, :_float
        field_reader :track_made_good_degrees_true, 8, :_float

        # Magnetic variation in degrees
        # @!parse attr_reader :magnetic_variation_degrees
        # @return [Float]
        def magnetic_variation_degrees
          self.class.nsew_signed_float(@fields[10], @fields[11])
        end

        field_reader :faa_mode, 12, :_string
      end
    end
  end
end
