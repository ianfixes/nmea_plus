require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class WPL < NMEAPlus::Message::NMEA::NMEAMessage
        def latitude
          _degrees_minutes_to_decimal(@fields[1], @fields[2])
        end

        def longitude
          _degrees_minutes_to_decimal(@fields[3], @fields[4])
        end

        field_reader :name, 5, :_string
      end
    end
  end
end
