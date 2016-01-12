require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # Base class for "Class B CS Position Report" messages (18 and 19)
        class VDMMsgClassBCSPosition < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :speed_over_ground, 46, 10, :_U, 10
          payload_reader :position_10m_accuracy?, 56, 1, :_b
          payload_reader :longitude, 57, 28, :_I, 60 * 10**4, 181
          payload_reader :latitude, 85, 27, :_I, 60 * 10**4, 91
          payload_reader :course_over_ground, 112, 12, :_U, 10
          payload_reader :true_heading, 124, 9, :_u, 511
          payload_reader :time_stamp, 133, 6, :_u

        end

        # Type 18: Standard Class B CS Position Report
        class VDMMsg18 < VDMMsgClassBCSPosition
          payload_reader :cs_unit?, 141, 1, :_b
          payload_reader :display?, 142, 1, :_b
          payload_reader :dsc?, 143, 1, :_b
          payload_reader :band?, 144, 1, :_b
          payload_reader :accept_message_22?, 145, 1, :_b
          payload_reader :assigned?, 146, 1, :_b
          payload_reader :raim?, 147, 1, :_b
        end

        # Type 19: Extended Class B CS Position Report
        class VDMMsg19 < VDMMsgClassBCSPosition
          payload_reader :name, 143, 120, :_t
          payload_reader :ship_cargo_type, 263, 8, :_e
          payload_reader :ship_dimension_to_bow, 271, 9, :_u
          payload_reader :ship_dimension_to_stern, 280, 9, :_u
          payload_reader :ship_dimension_to_port, 289, 6, :_u
          payload_reader :ship_dimension_to_starboard, 295, 6, :_u
          payload_reader :epfd_type, 301, 4, :_e
          payload_reader :raim?, 305, 1, :_b
          payload_reader :dte_ready?, 306, 1, :_nb
          payload_reader :assigned?, 307, 1, :_b

          # @!parse attr_reader :ship_cargo_type_description
          # @return [String] Cargo type description
          def ship_cargo_type_description
            get_ship_cargo_type_description(ship_cargo_type)
          end

        end

      end
    end
  end
end
