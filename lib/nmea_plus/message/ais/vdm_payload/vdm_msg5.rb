require 'nmea_plus/message/ais/vdm_payload/vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 5: Static and Voyage Related Data
        class VDMMsg5 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

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
          # @return [Time] Estimated Time of Arrival, in UTC
          def eta
            month  = _u(274, 4)
            day    = _u(278, 5)
            hour   = _u(283, 5)
            minute = _u(288, 6)
            _get_date_mdhm(month, day, hour, minute)
          end

          payload_reader :static_draught, 294, 8, :_U, 10
          payload_reader :destination, 302, 120, :_t
          payload_reader :dte_ready?, 422, 1, :_nb

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
