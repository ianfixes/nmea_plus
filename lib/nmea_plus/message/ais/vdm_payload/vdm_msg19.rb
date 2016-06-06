require_relative 'vdm_msg_class_b_cs_position'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 19: Extended Class B CS Position Report
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
