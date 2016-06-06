require_relative 'vdm_msg_station_report'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 4: Base Station Report
        # @see VDMMsgStationReport
        class VDMMsg4 < VDMMsgStationReport; end

      end
    end
  end
end
