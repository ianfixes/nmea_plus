
require 'nmea_plus/message/base'

module NMEAPlus
  module Message

    # A container for all {AISMessage} types.
    # Most definitions were sourced from http://catb.org/gpsd/AIVDM.html
    # @see NMEAPlus::Message::AIS::AISMessage Base class for all AIS messages
    # @see NMEAPlus::Message::AIS::VDMPayload::VDMMsg Base class for all AIS binary payloads
    module AIS

      # The base NMEA message type for AIS.  This is currently a thin wrapper, as {VDM} is the only defined message type.
      class AISMessage < NMEAPlus::Message::Base
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
        # @return [String] The two-character "talker ID" of the message
        def message_type
          data_type[2..-1]
        end

      end
    end
  end
end
