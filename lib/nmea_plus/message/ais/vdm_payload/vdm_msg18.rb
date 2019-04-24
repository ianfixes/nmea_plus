require 'nmea_plus/message/ais/vdm_payload/vdm_msg_class_b_cs_position'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 18: Standard Class B CS Position Report
        class VDMMsg18 < VDMMsgClassBCSPosition
          payload_reader :cs_unit?, 141, 1, :_b
          payload_reader :display?, 142, 1, :_b
          payload_reader :dsc?, 143, 1, :_b
          payload_reader :band?, 144, 1, :_b
          payload_reader :accept_message_22?, 145, 1, :_b
          payload_reader :assigned?, 146, 1, :_b
          payload_reader :raim?, 147, 1, :_b
        end

      end
    end
  end
end
