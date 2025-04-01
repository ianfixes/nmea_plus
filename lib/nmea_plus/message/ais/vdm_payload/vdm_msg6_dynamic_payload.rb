require "nmea_plus/message/ais/vdm_payload/payload"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Base class for dynamic payloads (subtypes) of AIS VDM message 6
        class VDMMsg6DynamicPayload < NMEAPlus::Message::AIS::VDMPayload::Payload; end

        # Placeholder for undefined message 6 payload subtypes
        class VDMMsg6Undefined < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload
          payload_reader :application_data_2b, 56, 952, :_d
          payload_reader :application_data_6b, 56, 952, :_6b_string
          payload_reader :application_data_8b, 56, 952, :_8b_data_string
        end

      end
    end
  end
end
