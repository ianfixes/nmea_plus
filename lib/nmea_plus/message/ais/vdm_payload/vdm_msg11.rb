require_relative 'vdm_msg4'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 11: UTC/Date Response
        # According to the unoffical spec: "Identical to message 4, with the semantics of a response to inquiry."
        class VDMMsg11 < VDMMsgStationReport; end

      end
    end
  end
end
