require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        class VDMMsg8 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
          payload_reader :designated_area_code, 40, 10, :_u
          payload_reader :functional_id, 50, 6, :_u
          payload_reader :application_data_2b, 56, 952, :_d
          payload_reader :application_data_6b, 56, 952, :_6b_string
          payload_reader :application_data_8b, 56, 952, :_8b_data_string

          payload_reader :ais_version, 38, 2, :_u
          payload_reader :imo_number, 40, 30, :_u
          payload_reader :callsign, 70, 42, :_t
          payload_reader :name, 112, 120, :_t
          payload_reader :ship_cargo_type, 232, 8, :_e
          payload_reader :ship_dimension_to_bow, 240, 9, :_u
          payload_reader :ship_dimension_to_stern, 249, 9, :_u
          payload_reader :ship_dimension_to_port, 258, 6, :_u
          payload_reader :ship_dimension_to_starboard, 264, 6, :_u
          payload_reader :epfd_type, 270, 4, :_e

          # @!parse attr_reader :eta
          # @return [Time]
          def eta
            now = Time.now
            Time.new(now.year,
                     _u(274, 4),
                     _u(278, 5),
                     _u(283, 5),
                     _u(288, 6),
                     0)
          end

          payload_reader :static_draught, 294, 8, :_U, 1
          payload_reader :destination, 302, 120, :_t
          payload_reader :dte?, 422, 1, :_b

        end
      end
    end
  end
end
