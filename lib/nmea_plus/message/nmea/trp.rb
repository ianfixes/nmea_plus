require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # TRP - TRANSIT Satellite Predicted Direction of Rise
      # TRANSIT system is not operational, no recommended replacement
      class TRP < NMEAPlus::Message::NMEA::NMEAMessage
        # Southeasterly = SE, southwesterly = SW
        field_reader :predicted_rise_direction, 1, :_string
      end
    end
  end
end
