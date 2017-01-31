require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TRP - TRANSIT Satellite Predicted Direction of Rise
      class TRP < NMEAPlus::Message::NMEA::NMEAMessage
        field_reader :predicted_rise_direction, 1, :_string
      end
    end
  end
end
