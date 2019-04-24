require 'nmea_plus/message/ais/vdm_payload/vdm_msg8_dynamic_payload'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # Type 8: Binary Broadcast Message Subtype: Meteorological and Hydrological Data (IMO289)
        class VDMMsg8d200f10 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg8DynamicPayload

          payload_reader :european_vessel_id, 56, 48, :_t
          payload_reader :dimension_length, 104, 13, :_U, 10, 0
          payload_reader :dimension_beam, 117, 10, :_U, 10, 0
          payload_reader :ship_type, 127, 14, :_e

          # @!parse attr_reader :ship_type_description
          # @return [String] ship type description
          def ship_type_description
            get_eri_description(ship_type)
          end

          payload_reader :hazardous_cargo, 141, 3, :_e

          # @!parse attr_reader :hazardous_cargo_description
          # @return [String] hazardous cargo description
          def hazardous_cargo_description
            case hazardous_cargo
            when 0 then return "0 blue cones/lights"
            when 1 then return "1 blue cone/light"
            when 2 then return "2 blue cones/lights"
            when 3 then return "3 blue cones/lights"
            when 4 then return "B-Flag"
            end
            "Unknown"
          end

          payload_reader :dimension_draught, 144, 11, :_U, 100, 0
          payload_reader :load_status, 155, 2, :_e, 0

          # @!parse attr_reader :load_status_description
          # @return [String] load status description
          def load_status_description
            case load_status
            when 1 then return "Unloaded"
            when 2 then return "Loaded"
            end
            nil
          end

          payload_reader :speed_quality, 157, 1, :_b
          payload_reader :course_quality, 158, 1, :_b
          payload_reader :heading_quality, 159, 1, :_b

          # @param code [Integer]
          # @return [String] ERI SOLAS ship type
          def get_eri_solas_description(code)
            return nil if code < 1
            return nil if 99 < code
            i = code.to_i
            major = case i / 10
                    when 3 then "Vessel"
                    when 7 then "Cargo ship"
                    when 8 then "Tanker"
                    when 9 then "Other types of ship"
                    else "SOLAS1-#{i / 10}"
                    end
            minor = case i % 10
                    when 0 then "All ships of this type"
                    when 1 then "Towing"
                    when 8 then "Tanker"
                    when 9 then "No additional information"
                    else "SOLAS2-#{i % 10}"
                    end
            "#{major} (#{minor})"
          end

          # @param code [Integer]
          # @return [String] ERI description
          def get_eri_description(code)
            case code
            when 1..99 then get_eri_solas_description(code)
            when 1500 then "General cargo vessel maritime"
            when 1510 then "Unit carrier maritime"
            when 1520 then "Bulk carrier maritime"
            when 1530 then "Tanker"
            when 1540 then "Liquified gas tanker"
            when 1850 then "Pleasure craft, longer than 20m"
            when 1900 then "Fast ship"  # You've never heard of the Maritime Falcon?
            when 1910 then "Hydrofoil"
            when 8000 then "Vessel, type unknown"
            when 8010 then "Motor freighter"
            when 8020 then "Motor tanker"
            when 8021 then "Motor tanker, liquid cargo, type N"
            when 8022 then "Motor tanker, liquid cargo, type C"
            when 8023 then "Motor tanker, dry cargo as if liquid"
            when 8030 then "Container vessel"
            when 8040 then "Gas tanker"
            when 8050 then "Motor freighter, tug"
            when 8060 then "Motor tanker, tug"
            when 8070 then "Motor freighter with one or more ships alongside"
            when 8080 then "Motor freighter with tanker"
            when 8090 then "Motor freighter pushing one or more freighters"
            when 8100 then "Motor freighter pushing at least one tank-ship"
            when 8110 then "Tug, freighter"
            when 8120 then "Tug, tanker"
            when 8130 then "Tug freighter, coupled"
            when 8140 then "Tug, freighter/tanker, coupled"
            when 8150 then "Freightbarge"
            when 8160 then "Tankbarge"
            when 8161 then "Tankbarge, liquid cargo, type N"
            when 8162 then "Tankbarge, liquid cargo, type C"
            when 8163 then "Tankbarge, dry cargo as if liquid"
            when 8170 then "Freightbarge with containers"
            when 8180 then "Tankbarge, gas"
            when 8210 then "Pushtow, one cargo barge"
            when 8220 then "Pushtow, two cargo barges"
            when 8230 then "Pushtow, three cargo barges"
            when 8240 then "Pushtow, four cargo barges"
            when 8250 then "Pushtow, five cargo barges"
            when 8260 then "Pushtow, six cargo barges"
            when 8270 then "Pushtow, seven cargo barges"
            when 8280 then "Pushtow, eigth cargo barges"
            when 8290 then "Pushtow, nine or more barges"
            when 8310 then "Pushtow, one tank/gas barge"
            when 8320 then "Pushtow, two barges at least one tanker or gas barge"
            when 8330 then "Pushtow, three barges at least one tanker or gas barge"
            when 8340 then "Pushtow, four barges at least one tanker or gas barge"
            when 8350 then "Pushtow, five barges at least one tanker or gas barge"
            when 8360 then "Pushtow, six barges at least one tanker or gas barge"
            when 8370 then "Pushtow, seven barges at least one tanker or gas barge"
            when 8380 then "Pushtow, eight barges at least one tanker or gas barge"
            when 8390 then "Pushtow, nine or more barges at least one tanker or gas barge"
            when 8400 then "Tug, single"
            when 8410 then "No tug, one or more tows"
            when 8420 then "Tug, assisting a vessel or linked combination"
            when 8430 then "Pushboat, single"
            when 8440 then "Passenger ship, ferry, cruise ship, red cross ship"
            when 8441 then "Ferry"
            when 8442 then "Red Cross ship"
            when 8443 then "Cruise ship"
            when 8444 then "Passenger ship without accommodation"
            when 8450 then "Service vessel, police partrol, port service"
            when 8460 then "Vessel, work maint. craft, derrick, cable ship, buoy ship, dredge"
            when 8470 then "Object, towed, not otherwise specified"
            when 8480 then "Fishing boat"
            when 8490 then "Bunkership"
            when 8500 then "Barge, tanker, chemical"
            when 8510 then "Object, not otherwise specified"
            end
          end

        end
      end
    end
  end
end
