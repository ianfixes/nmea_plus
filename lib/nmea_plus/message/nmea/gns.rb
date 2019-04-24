
require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # GNS - Fix data
      class GNS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :fix_time, 1, :_utctime_hms

        # Latitude in degrees
        # @!parse attr_reader :latitude
        # @return [Float]
        def latitude
          self.class.degrees_minutes_to_decimal(@fields[2], @fields[3])
        end

        # Longitude in degrees
        # @!parse attr_reader :longitude
        # @return [Float]
        def longitude
          self.class.degrees_minutes_to_decimal(@fields[4], @fields[5])
        end

        field_reader :mode, 6, :_string
        field_reader :satellites, 7, :_integer
        field_reader :hdrop, 8, :_string
        field_reader :altitude, 9, :_float
        field_reader :geoidal_separation, 10, :_float
        field_reader :data_age, 11, :_float
        field_reader :differential_reference_station_id, 12, :_integer
      end
    end
  end
end
