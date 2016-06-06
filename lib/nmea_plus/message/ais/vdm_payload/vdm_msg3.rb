require_relative 'vdm_msg_cnb'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 3: Position report class A, which is really {VDMMsgCNB}
        class VDMMsg3 < VDMMsgCNB; end
      end
    end
  end
end
