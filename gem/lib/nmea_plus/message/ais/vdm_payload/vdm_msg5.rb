require_relative 'vdm_msg'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
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

          def ship_cargo_type_description
            case ship_cargo_type
            when 0 then return nil
            when 1...19 then return "(future use)"
            when 20 then return "WIG (any)"
            when 21 then return "WIG Hazardous category A"
            when 22 then return "WIG Hazardous category B"
            when 23 then return "WIG Hazardous category C"
            when 24 then return "WIG Hazardous category D"
            when 25...29 then return "WIG (future use)"
            when 30 then return "Fishing"
            when 31 then return "Towing"
            when 32 then return "Towing (large)"
            when 33 then return "Dredging/underwater ops"
            when 34 then return "Diving ops"
            when 35 then return "Military ops"
            when 36 then return "Sailing"
            when 37 then return "Pleasure craft"
            when 38, 39 then return "Reserved"
            when 40 then return "High Speed Craft"
            when 41 then return "HSC Hazardous category A"
            when 42 then return "HSC Hazardous category B"
            when 43 then return "HSC Hazardous category C"
            when 44 then return "HSC Hazardous category D"
            when 45...48 then return "HSC (reserved)"
            when 49 then return "HSC (no additional information)"
            when 50 then return "Pilot Vessel"
            when 51 then return "Search and Rescue Vessel"
            when 52 then return "Tug"
            when 53 then return "Port Tender"
            when 54 then return "Anti-pollution equipment"
            when 55 then return "Law Enforcement"
            when 56, 57 then return "Spare - Local Vessel"
            when 58 then return "Medical Transport"
            when 59 then return "Noncombatant ship according to RR Resolution No. 18"
            when 60 then return "Passenger"
            when 61 then return "Passenger, Hazardous category A"
            when 62 then return "Passenger, Hazardous category B"
            when 63 then return "Passenger, Hazardous category C"
            when 64 then return "Passenger, Hazardous category D"
            when 65..68 then return "Passenger, Reserved for future use"
            when 69 then return "Passenger, No additional information"
            when 70 then return "Cargo"
            when 71 then return "Cargo, Hazardous category A"
            when 72 then return "Cargo, Hazardous category B"
            when 73 then return "Cargo, Hazardous category C"
            when 74 then return "Cargo, Hazardous category D"
            when 75..78 then return "Cargo, Reserved for future use"
            when 79 then return "Cargo, No additional information"
            when 80 then return "Tanker"
            when 81 then return "Tanker, Hazardous category A"
            when 82 then return "Tanker, Hazardous category B"
            when 83 then return "Tanker, Hazardous category C"
            when 84 then return "Tanker, Hazardous category D"
            when 85.88 then return "Tanker, Reserved for future use"
            when 89 then return "Tanker, No additional information"
            when 90 then return "Other Type"
            when 91 then return "Other Type, Hazardous category A"
            when 92 then return "Other Type, Hazardous category B"
            when 93 then return "Other Type, Hazardous category C"
            when 94 then return "Other Type, Hazardous category D"
            when 95..98 then return "Other Type, Reserved for future use"
            when 99 then return "Other Type, no additional information"
            end
          end

        end
      end
    end
  end
end
