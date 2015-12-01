
require_relative "../base"

module NMEAPlus
  module Message
    module NMEA

      class NMEAMessage < NMEAPlus::Message::Base
        def talker
          data_type[0..1]
        end

        def message_type
          data_type[2..-1]
        end

        def _av_boolean(data)
          case data
          when 'A' then return true
          when 'V' then return false
          end
          nil
        end

        def _10_boolean(data)
          case data
          when '1' then return true
          when '0' then return false
          end
          nil
        end

      end
    end
  end
end
