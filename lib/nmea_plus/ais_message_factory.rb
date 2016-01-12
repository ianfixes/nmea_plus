
require_relative 'message_factory'

require_relative 'message/ais/vdm'

module NMEAPlus

  # Defines a factory for AIS messages, which will all use {NMEAPlus::Message::AIS::AISMessage} as their base.
  # The factory extracts the NMEA data type (prefixed by a 2-character "talker ID"), and looks for a class with
  # that name within the NMEA message namespace.
  class AISMessageFactory < MessageFactory
    # @return [String] The name of the parent module: AIS
    def self.parent_module
      "AIS"
    end

    # Match all AIS messages as their generic counterparts.  AIVDM becomes VDM, etc.
    # @param data_type [String] The data_type of the AIS message (e.g. the AIVDM of "$AIVDM,12,3,,4,5*00")
    # @return [String] The data_type that we will attempt to use in decoding the message (e.g. VDM)
    def self.alternate_data_type(data_type)
      # match last 3 digits (get rid of talker)
      data_type[2..4]
    end
  end
end
