
require 'nmea_plus/message/base'

module NMEAPlus
  module Message
    # A container for all {NMEAMessage} types.
    # Most definitions were sourced from http://www.catb.org/gpsd/NMEA.txt
    module NMEA

      # The base class for NMEA messages includes a few NMEA-specific parsing functions
      # beyond the base NMEA class.
      class NMEAMessage < NMEAPlus::Message::Base

        # The first two characters of the NMEA message type
        # @!parse attr_accessor :talker
        # @return [String] The two-character "talker ID" of the message
        def talker
          data_type[0..1]
        end

        # The generic type of the NMEA message.
        # NMEA message types are 5 characters (or so): the first 2 are the talker ID, and the
        # remaining characters are the generic message type.
        # @!parse attr_accessor :message_type
        # @return [String] The generic part of the NMEA "data type" of the message
        def message_type
          data_type[2..-1]
        end

        # Convert a string true/false (encoded as A=true, V=false) to boolean.
        # This function is meant to be passed as a formatter to {field_reader}.
        # @param field [String] the value in the field to be checked
        # @return [bool] The value in the field or nil
        def self._av_boolean(field)
          case field
          when 'A' then return true
          when 'V' then return false
          end
          nil
        end

        # Convert a string true/false (encoded as 1=true, 0=false) to boolean.
        # This function is meant to be passed as a formatter to {field_reader}.
        # @param field [String] the value in the field to be checked
        # @return [bool] The value in the field or nil
        def self._10_boolean(field)
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
