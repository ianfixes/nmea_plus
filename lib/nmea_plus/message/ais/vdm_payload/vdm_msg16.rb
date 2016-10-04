require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # AIS Type 16: Assignment Mode Command
        class VDMMsg16 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
          payload_reader :destination1_mmsi, 40, 30, :_u, 0
          payload_reader :destination1_offset, 70, 12, :_u
          payload_reader :destination1_increment, 82, 10, :_u

          payload_reader :destination2_mmsi, 92, 30, :_u, 0
          payload_reader :destination2_offset, 122, 12, :_u
          payload_reader :destination2_increment, 134, 10, :_u
        end
      end
    end
  end
end
