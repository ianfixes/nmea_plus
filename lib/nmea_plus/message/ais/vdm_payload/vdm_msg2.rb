require 'nmea_plus/message/ais/vdm_payload/vdm_msg_cnb'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 2: Position report class A, which is really {VDMMsgCNB}
        class VDMMsg2 < VDMMsgCNB; end
      end
    end
  end
end
