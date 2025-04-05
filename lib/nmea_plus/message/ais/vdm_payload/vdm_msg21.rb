require "nmea_plus/message/ais/vdm_payload/vdm_msg"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 21: Aid-to-Navigation Report
        class VDMMsg21 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          # TODO: Navaid type descriptions (there are 32 of them)
          payload_reader :aid_type, 38, 5, :_e
          payload_reader :name, 43, 120, :_t

          payload_reader :position_10m_accuracy?, 163, 1, :_b
          payload_reader :longitude, 164, 28, :_I, 60 * (10**4), 181
          payload_reader :latitude, 192, 27, :_I, 60 * (10**4), 91

          payload_reader :ship_dimension_to_bow, 219, 9, :_u
          payload_reader :ship_dimension_to_stern, 228, 9, :_u
          payload_reader :ship_dimension_to_port, 237, 6, :_u
          payload_reader :ship_dimension_to_starboard, 243, 6, :_u
          payload_reader :epfd_type, 249, 4, :_e
          payload_reader :time_stamp, 253, 6, :_u
          payload_reader :off_position?, 259, 1, :_b

          payload_reader :raim?, 268, 1, :_b
          payload_reader :virtual_aid?, 269, 1, :_b
          payload_reader :assigned?, 270, 1, :_b

          payload_reader :name_extension, 272, 88, :_t

          # TODO: full name property?
        end
      end
    end
  end
end
