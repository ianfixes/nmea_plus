require "nmea_plus/message/ais/vdm_payload/payload"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Base class for {VDMMsg8#dp dynamic payload}s (subtypes) of {VDMMsg8 AIS VDM message 8}
        class VDMMsg8DynamicPayload < NMEAPlus::Message::AIS::VDMPayload::Payload; end

        # Placeholder for undefined message 8 payload subtypes
        class VDMMsg8Undefined < VDMMsg8DynamicPayload
          payload_reader :application_data_2b, 56, 952, :_d
          payload_reader :application_data_6b, 56, 952, :_6b_string
          payload_reader :application_data_8b, 56, 952, :_8b_data_string
        end

      end
    end
  end
end
