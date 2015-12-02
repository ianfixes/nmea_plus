require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # Type 4: Base Station Report
        class VDMMsg4 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

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

          # @!parse attr_reader :longitude
          # @return [Float]
          def longitude
            _I(79, 28, 4) / 60
          end

          # @!parse attr_reader :latitude
          # @return [Float]
          def latitude
            _U(107, 27, 4) / 60
          end

          payload_reader :epfd_type, 134, 4, :_e
          payload_reader :raim?, 148, 1, :_b

        end
      end
    end
  end
end
