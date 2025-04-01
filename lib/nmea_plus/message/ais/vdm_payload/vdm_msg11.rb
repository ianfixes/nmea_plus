require "nmea_plus/message/ais/vdm_payload/vdm_msg_station_report"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 11: UTC/Date Response
        # According to the unoffical spec: "Identical to message 4, with the semantics of a response to inquiry."
        # @see VDMMsgStationReport
        class VDMMsg11 < VDMMsgStationReport; end

      end
    end
  end
end
