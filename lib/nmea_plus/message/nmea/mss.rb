require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class MSS < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :signal_strength_dbu, 1, :_float
        field_reader :snr_db, 2, :_float
        field_reader :beacon_frequency_khz, 3, :_float
        field_reader :beacon_data_rate_bps, 4, :_integer
        field_reader :unknown_field, 5, :_integer
      end
    end
  end
end
