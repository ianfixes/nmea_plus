require 'nmea_plus/message/ais/vdm_payload/vdm_msg6_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Type 6: Binary Addressed Message Subtype: GLA Aid to Navigation Monitoring Data
        class VDMMsg6d235f10 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg6DynamicPayload

          payload_reader :analog_internal, 88, 10, :_U, 20, 0
          payload_reader :analog_external1, 98, 10, :_U, 20, 0
          payload_reader :analog_external2, 108, 10, :_U, 20, 0
          payload_reader :racon_status, 118, 2, :_u

          # RACON status description
          # @!parse attr_reader :racon_status_description
          # @return [String] RACON status description
          def racon_status_description
            case racon_status
            when 0 then "no RACON installed"
            when 1 then "RACON not monitored"
            when 2 then "RACON operational"
            when 3 then "RACON ERROR"
            end
          end

          payload_reader :racon_light_status, 120, 2, :_u

          # @!parse attr_reader :racon_light_status_description
          # @return [String] RACON light status description
          def racon_light_status_description
            case racon_light_status
            when 0 then "no light or monitoring"
            when 1 then "ON"
            when 2 then "OFF"
            when 3 then "ERROR"
            end
          end

          payload_reader :racon_alarm?, 122, 1, :_b
          payload_reader :digital_input7?, 123, 1, :_b
          payload_reader :digital_input6?, 124, 1, :_b
          payload_reader :digital_input5?, 125, 1, :_b
          payload_reader :digital_input4?, 126, 1, :_b
          payload_reader :digital_input3?, 127, 1, :_b
          payload_reader :digital_input2?, 128, 1, :_b
          payload_reader :digital_input1?, 129, 1, :_b
          payload_reader :digital_input0?, 130, 1, :_b
        end
      end
    end
  end
end
