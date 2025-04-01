require "nmea_plus/message/ais/vdm_payload/payload"
require "nmea_plus/message/ais/vdm_payload/mmsi_info"

module NMEAPlus
  module Message
    module AIS
      module VDMPayload

        # The base class for the {NMEAPlus::Message::AIS::VDM#ais AIS payload}, which uses its own encoding for its own subtypes
        class VDMMsg < NMEAPlus::Message::AIS::VDMPayload::Payload

          payload_reader :message_type, 0, 6, :_u
          payload_reader :repeat_indicator, 6, 2, :_u
          payload_reader :source_mmsi, 8, 30, :_u

          # Detailed information produced from the MMSI
          # @!parse attr_reader :source_mmsi_info
          # @return [MMSIInfo] MMSI information structure
          def source_mmsi_info
            MMSIInfo.new(source_mmsi)
          end

          # The ship cargo type description lookup table
          # @param code [Integer] The cargo type id
          # @return [String] Cargo type description
          def get_ship_cargo_type_description(code)
            case code
            when 0 then nil
            when 1...19 then "(future use)"
            when 20 then "WIG (any)"
            when 21 then "WIG Hazardous category A"
            when 22 then "WIG Hazardous category B"
            when 23 then "WIG Hazardous category C"
            when 24 then "WIG Hazardous category D"
            when 25...29 then "WIG (future use)"
            when 30 then "Fishing"
            when 31 then "Towing"
            when 32 then "Towing (large)"
            when 33 then "Dredging/underwater ops"
            when 34 then "Diving ops"
            when 35 then "Military ops"
            when 36 then "Sailing"
            when 37 then "Pleasure craft"
            when 38, 39 then "Reserved"
            when 40 then "High Speed Craft"
            when 41 then "HSC Hazardous category A"
            when 42 then "HSC Hazardous category B"
            when 43 then "HSC Hazardous category C"
            when 44 then "HSC Hazardous category D"
            when 45...48 then "HSC (reserved)"
            when 49 then "HSC (no additional information)"
            when 50 then "Pilot Vessel"
            when 51 then "Search and Rescue Vessel"
            when 52 then "Tug"
            when 53 then "Port Tender"
            when 54 then "Anti-pollution equipment"
            when 55 then "Law Enforcement"
            when 56, 57 then "Spare - Local Vessel"
            when 58 then "Medical Transport"
            when 59 then "Noncombatant ship according to RR Resolution No. 18"
            when 60 then "Passenger"
            when 61 then "Passenger, Hazardous category A"
            when 62 then "Passenger, Hazardous category B"
            when 63 then "Passenger, Hazardous category C"
            when 64 then "Passenger, Hazardous category D"
            when 65..68 then "Passenger, Reserved for future use"
            when 69 then "Passenger, No additional information"
            when 70 then "Cargo"
            when 71 then "Cargo, Hazardous category A"
            when 72 then "Cargo, Hazardous category B"
            when 73 then "Cargo, Hazardous category C"
            when 74 then "Cargo, Hazardous category D"
            when 75..78 then "Cargo, Reserved for future use"
            when 79 then "Cargo, No additional information"
            when 80 then "Tanker"
            when 81 then "Tanker, Hazardous category A"
            when 82 then "Tanker, Hazardous category B"
            when 83 then "Tanker, Hazardous category C"
            when 84 then "Tanker, Hazardous category D"
            when 85.88 then "Tanker, Reserved for future use"
            when 89 then "Tanker, No additional information"
            when 90 then "Other Type"
            when 91 then "Other Type, Hazardous category A"
            when 92 then "Other Type, Hazardous category B"
            when 93 then "Other Type, Hazardous category C"
            when 94 then "Other Type, Hazardous category D"
            when 95..98 then "Other Type, Reserved for future use"
            when 99 then "Other Type, no additional information"
            end
          end

          # An MMSI is associated with an auxiliary craft when it is of the form 98XXXYYYY
          def auxiliary_craft?
            source_mmsi_info.category == :auxiliary_craft
          end

          # @param code [Integer] The navigational status id
          # @return [String] Navigational status description
          def get_navigational_status_description(code)
            return nil if code.nil?

            case code
            when 0 then "Under way using engine"
            when 1 then "At anchor"
            when 2 then "Not under command"
            when 3 then "Restricted manoeuverability"
            when 4 then "Constrained by her draught"
            when 5 then "Moored"
            when 6 then "Aground"
            when 7 then "Engaged in Fishing"
            when 8 then "Under way sailing"
            when 9...13 then "Reserved for future use"
            when 14 then "AIS-SART active"
            else
              "Not defined"
            end
          end
        end

        # We haven't defined all the {NMEAPlus::Message::AIS::VDM#ais AIS payload} types, so this is a catch-all
        class VDMMsgUndefined < VDMMsg; end

      end
    end
  end
end
