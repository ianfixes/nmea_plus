require 'nmea_plus/message/ais/vdm_payload/vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # AIS Type 24: Static Data Report
        class VDMMsg24 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg

          payload_reader :part_number, 38, 2, :_u

          # Override default bitstring setting to dynamically calculate what fields belong in this message
          # which can be either part A or part B dpeending on the {#part_number} field
          def payload_bitstring=(val)
            super

            case part_number
            when 0
              self.class.payload_reader :name, 40, 120, :_t
            when 1
              self.class.payload_reader :ship_cargo_type, 40, 8, :_e
              self.class.payload_reader :vendor_id, 48, 18, :_t
              self.class.payload_reader :model_code, 66, 4, :_u
              self.class.payload_reader :serial_number, 70, 20, :_u
              self.class.payload_reader :callsign, 90, 42, :_t

              # If the MMSI is that of an auxiliary craft, these 30 bits are read as the MMSI of the mother ship.
              # otherwise they are the vessel dimensions
              if auxiliary_craft?
                self.class.payload_reader :mothership_mmsi, 132, 30, :_u
              else
                self.class.payload_reader :ship_dimension_to_bow, 132, 9, :_u
                self.class.payload_reader :ship_dimension_to_stern, 141, 9, :_u
                self.class.payload_reader :ship_dimension_to_port, 150, 6, :_u
                self.class.payload_reader :ship_dimension_to_starboard, 156, 6, :_u
              end
            end
          end

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
