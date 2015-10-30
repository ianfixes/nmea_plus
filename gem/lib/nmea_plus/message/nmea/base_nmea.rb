
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

        def _av_boolean data
          case data
          when 'A'; return true
          when 'V'; return false
          end
          nil
        end

      end
    end
  end
end
