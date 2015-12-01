
require_relative "../base"

module NMEAPlus
  module Message
    # A container for all {NMEAMessage} typs.
    module NMEA

      # The base class for NMEA messages includes a few more NMEA-specific parsing functions
      class NMEAMessage < NMEAPlus::Message::Base

        # NMEA message types are 5 characters, the first 2 of which are the talker ID
        # @!parse attr_accessor :talker
        # @return [String] The two-character "talker ID" of the message
        def talker
          data_type[0..1]
        end

        # NMEA message types are 5 characters (or so), the last of which are the message type
        # @!parse attr_accessor :message_type
        # @return [String] The two-character "talker ID" of the message
        def message_type
          data_type[2..-1]
        end

        # Convert a string true/false (encoded as A=true, V=false) to boolean
        # @param field [String] the value in the field to be checked
        # @return [bool] The value in the field or nil
        def _av_boolean(field)
          case field
          when 'A' then return true
          when 'V' then return false
          end
          nil
        end

        # Convert a string true/false (encoded as 1=true, 0=false) to boolean
        # @param field [String] the value in the field to be checked
        # @return [bool] The value in the field or nil
        def _10_boolean(field)
          case field
          when '1' then return true
          when '0' then return false
          end
          nil
        end

      end
    end
  end
end
