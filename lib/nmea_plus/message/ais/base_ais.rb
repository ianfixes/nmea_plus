
require_relative "../base"

module NMEAPlus
  module Message
    # A container for all {AISMessage} types.
    module AIS

      class AISMessage < NMEAPlus::Message::Base
        # NMEA (AIS) message types are 5 characters, the first 2 of which are the talker ID
        # @!parse attr_accessor :talker
        # @return [String] The two-character "talker ID" of the message
        def talker
          data_type[0..1]
        end

        # NMEA (AIS) message types are 5 characters (or so), the last of which are the message type
        # @!parse attr_accessor :message_type
        # @return [String] The two-character "talker ID" of the message
        def message_type
          data_type[2..-1]
        end

      end
    end
  end
end
