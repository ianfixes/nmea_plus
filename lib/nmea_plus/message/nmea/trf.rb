require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TRF - TRANSIT Fix Data
      # Time, date, position and information related to a TRANSIT fix.
      # TRANSIT system is not operational, no recommended replacement.
      class TRF < NMEAPlus::Message::NMEA::NMEAMessage
        # UTC of position fix: Date and time
        # @!parse attr_reader :utc_time
        # @return [Time]
        def utc_time
          self.class._utc_date_time(@fields[2], @fields[1])
        end

        # Latitude, N/S
        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          self.class.degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        # Longitude, E/W
        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          self.class.degrees_minutes_to_decimal(@fields[5], @fields[6])
        end

        # Elevation angle
        field_reader :elevation_angle, 7, :_float

        # Number of iterations
        field_reader :iterations, 8, :_integer

        # Number of Doppler intervals
        field_reader :doppler_intervals, 9, :_integer

        # Update distance, nautical miles
        field_reader :update_distance_nautical_miles, 10, :_float

        # Satellite ID
        field_reader :satellite, 11, :_integer

        # Data status
        field_reader :valid?, 12, :_av_boolean
      end
    end
  end
end
