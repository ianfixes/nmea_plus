require_relative "../base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # PASHR - RT300 proprietary roll and pitch sentence
      class PASHR < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :utc_time, 1, :_utctime_hms
        field_reader :heading_degrees, 2, :_float
        field_reader :heading_type, 3, :_string
        field_reader :roll_degrees, 4, :_float
        field_reader :pitch_degrees, 5, :_float
        field_reader :heave, 6, :_float
        field_reader :roll_stdev, 7, :_float
        field_reader :pitch_stdev, 8, :_float
        field_reader :heading_stdev, 9, :_float
        field_reader :aiding_status, 10, :_integer
        field_reader :imu_status, 11, :_integer
      end
    end
  end
end
