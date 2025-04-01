require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # LCD - Loran-C Signal Data
      class LCD < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :gri_tenth_microseconds, 1, :_integer
        field_reader :master_relative_snr, 2, :_float
        field_reader :master_relative_ecd, 3, :_float
        field_reader :time_difference_1_microseconds, 4, :_float
        field_reader :time_difference_1_signal?, 5, :_av_boolean
        field_reader :time_difference_2_microseconds, 6, :_float
        field_reader :time_difference_2_signal?, 7, :_av_boolean
        field_reader :time_difference_3_microseconds, 8, :_float
        field_reader :time_difference_3_signal?, 9, :_av_boolean
        field_reader :time_difference_4_microseconds, 10, :_float
        field_reader :time_difference_4_signal?, 11, :_av_boolean
        field_reader :time_difference_5_microseconds, 12, :_float
        field_reader :time_difference_5_signal?, 13, :_av_boolean
      end
    end
  end
end
