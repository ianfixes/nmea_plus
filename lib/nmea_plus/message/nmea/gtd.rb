require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # GTD - Geographic Location in Time Differences
      # Loran-C Time Difference (TD) lines of position for present vessel position.
      # The use of $--GLC is recommended
      # @see GLC
      class GTD < NMEAPlus::Message::NMEA::NMEAMessage
        # TD 1, micro-seconds
        field_reader :difference1, 1, :_float

        # TD 2, micro-seconds
        field_reader :difference2, 2, :_float

        # TD 3, micro-seconds
        field_reader :difference3, 3, :_float

        # TD 4, micro-seconds
        field_reader :difference4, 4, :_float

        # TD 5, micro-seconds
        field_reader :difference5, 5, :_float
      end
    end
  end
end
