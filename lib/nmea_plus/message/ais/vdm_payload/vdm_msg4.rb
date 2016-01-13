require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Base class for station reports
        # @see VDMMsg4
        # @see VDMMsg11
        class VDMMsgStationReport < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          # @!parse attr_reader :current_time
          # @return [Time] current time
          def current_time
            Time.new(_u(38, 14),
                     _u(52, 4),
                     _u(56, 5),
                     _u(61, 5),
                     _u(66, 6),
                     _u(72, 6))
          end

          payload_reader :position_10m_accuracy?, 78, 1, :_b
          payload_reader :longitude, 79, 28, :_I, 60 * 10**4, 181
          payload_reader :latitude, 107, 27, :_I, 60 * 10**4, 91
          payload_reader :epfd_type, 134, 4, :_e
          payload_reader :raim?, 148, 1, :_b

        end

        # AIS Type 4: Base Station Report
        # @see VDMMsgStationReport
        class VDMMsg4 < VDMMsgStationReport; end

        # AIS Type 11: UTC/Date Response
        # According to the unoffical spec: "Identical to message 4, with the semantics of a response to inquiry."
        # @see VDMMsgStationReport
        class VDMMsg11 < VDMMsgStationReport; end

      end
    end
  end
end
