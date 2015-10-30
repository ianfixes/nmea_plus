require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class ALM < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :total_messages, 1, :_integer
        field_reader :message_number, 2, :_integer
        field_reader :satellite_prn, 3, :_integer
        field_reader :gps_week, 4, :_integer
        field_reader :sv_health, 5, :_hex_to_integer
        field_reader :eccentricity, 6, :_hex_to_integer
        field_reader :reference_time, 7, :_hex_to_integer
        field_reader :inclination_angle, 8, :_hex_to_integer
        field_reader :ascension_rate, 9, :_hex_to_integer
        field_reader :semimajor_axis_root, 10, :_hex_to_integer
        field_reader :perigee_argument, 11, :_hex_to_integer
        field_reader :ascension_node_longitude, 12, :_hex_to_integer
        field_reader :mean_anomaly, 13, :_hex_to_integer
        field_reader :f0_clock, 14, :_hex_to_integer
        field_reader :f1_clock, 15, :_hex_to_integer
      end
    end
  end
end
