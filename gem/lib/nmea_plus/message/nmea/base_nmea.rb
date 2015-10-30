
require_relative "../base"

module NMEAPlus
  module Message
    module NMEA

      class NMEAMessage < NMEAPlus::Message::Base
        def talker
          return data_type[0..1]
        end

        def message_type
          return data_type[2..-1]
        end
      end

    end
  end
end
