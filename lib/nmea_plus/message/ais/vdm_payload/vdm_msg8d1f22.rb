require_relative 'vdm_msg8_dynamic_payload'
require_relative 'sub_area'

module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # Type 8: Binary Broadcast Message Subtype: Area Notice (addressed)
        class VDMMsg8d1f22 < NMEAPlus::Message::AIS::VDMPayload::VDMMsg8DynamicPayload

          def initialize
            super
            @sub_areas = []
          end

          def payload_bitstring=(val)
            # Override default bitstring setting to dynamically calculate what SubArea fields belong in this message
            super

            @sub_areas = []
            (111...val.length).step(87).each do |pos|
              shape_id = _u(pos, 3)  # 3 bits at the beginning form the shape ID
              container = _dynamic_subarea_container(shape_id)
              container.payload_bitstring = payload_bitstring[pos..(pos + 87)]
              @sub_areas << container
            end
          end

          # Dynamically calculate what subarea type to use
          # which depends on the designated_area_code and functional_id
          # @private
          def _dynamic_subarea_container(shape_id)
            class_identifier = "NMEAPlus::Message::AIS::VDMPayload::SubArea#{shape_id}"
            ret = _object_by_name(class_identifier)
            return ret unless ret.nil?

            _object_by_name("NMEAPlus::Message::AIS::VDMPayload::SubAreaUndefined") # generic
          end

          payload_reader :linkage_id, 56, 10, :_u
          payload_reader :notice_id, 66, 7, :_u

          # @!parse attr_reader :notice_description
          # @return [String] Area notice description
          def notice_description
            case notice_id
            when 0 then "Caution Area: Marine mammals habitat"
            when 1 then "Caution Area: Marine mammals in area - reduce speed"
            when 2 then "Caution Area: Marine mammals in area - stay clear"
            when 3 then "Caution Area: Marine mammals in area - report sightings"
            when 4 then "Caution Area: Protected habitat - reduce speed"
            when 5 then "Caution Area: Protected habitat - stay clear"
            when 6 then "Caution Area: Protected habitat - no fishing or anchoring"
            when 7 then "Caution Area: Derelicts (drifting objects)"
            when 8 then "Caution Area: Traffic congestion"
            when 9 then "Caution Area: Marine event"
            when 10 then "Caution Area: Divers down"
            when 11 then "Caution Area: Swim area"
            when 12 then "Caution Area: Dredge operations"
            when 13 then "Caution Area: Survey operations"
            when 14 then "Caution Area: Underwater operation"
            when 15 then "Caution Area: Seaplane operations"
            when 16 then "Caution Area: Fishery - nets in water"
            when 17 then "Caution Area: Cluster of fishing vessels"
            when 18 then "Caution Area: Fairway closed"
            when 19 then "Caution Area: Harbour closed"
            when 20 then "Caution Area: Risk (define in associated text field)"
            when 21 then "Caution Area: Underwater vehicle operation"
            when 22 then "(reserved for future use)"
            when 23 then "Environmental Caution Area: Storm front (line squall)"
            when 24 then "Environmental Caution Area: Hazardous sea ice"
            when 25 then "Environmental Caution Area: Storm warning (storm cell or line of storms)"
            when 26 then "Environmental Caution Area: High wind"
            when 27 then "Environmental Caution Area: High waves"
            when 28 then "Environmental Caution Area: Restricted visibility (fog, rain, etc.)"
            when 29 then "Environmental Caution Area: Strong currents"
            when 30 then "Environmental Caution Area: Heavy icing"
            when 31 then "(reserved for future use)"
            when 32 then "Restricted Area: Fishing prohibited"
            when 33 then "Restricted Area: No anchoring."
            when 34 then "Restricted Area: Entry approval required prior to transit"
            when 35 then "Restricted Area: Entry prohibited"
            when 36 then "Restricted Area: Active military OPAREA"
            when 37 then "Restricted Area: Firing - danger area."
            when 38 then "Restricted Area: Drifting Mines"
            when 39 then "(reserved for future use)"
            when 40 then "Anchorage Area: Anchorage open"
            when 41 then "Anchorage Area: Anchorage closed"
            when 42 then "Anchorage Area: Anchorage prohibited"
            when 43 then "Anchorage Area: Deep draft anchorage"
            when 44 then "Anchorage Area: Shallow draft anchorage"
            when 45 then "Anchorage Area: Vessel transfer operations"
            when 46 then "(reserved for future use)"
            when 47 then "(reserved for future use)"
            when 48 then "(reserved for future use)"
            when 49 then "(reserved for future use)"
            when 50 then "(reserved for future use)"
            when 51 then "(reserved for future use)"
            when 52 then "(reserved for future use)"
            when 53 then "(reserved for future use)"
            when 54 then "(reserved for future use)"
            when 55 then "(reserved for future use)"
            when 56 then "Security Alert - Level 1"
            when 57 then "Security Alert - Level 2"
            when 58 then "Security Alert - Level 3"
            when 59 then "(reserved for future use)"
            when 60 then "(reserved for future use)"
            when 61 then "(reserved for future use)"
            when 62 then "(reserved for future use)"
            when 63 then "(reserved for future use)"
            when 64 then "Distress Area: Vessel disabled and adrift"
            when 65 then "Distress Area: Vessel sinking"
            when 66 then "Distress Area: Vessel abandoning ship"
            when 67 then "Distress Area: Vessel requests medical assistance"
            when 68 then "Distress Area: Vessel flooding"
            when 69 then "Distress Area: Vessel fire/explosion"
            when 70 then "Distress Area: Vessel grounding"
            when 71 then "Distress Area: Vessel collision"
            when 72 then "Distress Area: Vessel listing/capsizing"
            when 73 then "Distress Area: Vessel under assault"
            when 74 then "Distress Area: Person overboard"
            when 75 then "Distress Area: SAR area"
            when 76 then "Distress Area: Pollution response area"
            when 77 then "(reserved for future use)"
            when 78 then "(reserved for future use)"
            when 79 then "(reserved for future use)"
            when 80 then "Instruction: Contact VTS at this point/juncture"
            when 81 then "Instruction: Contact Port Administration at this point/juncture"
            when 82 then "Instruction: Do not proceed beyond this point/juncture"
            when 83 then "Instruction: Await instructions prior to proceeding beyond this point/juncture"
            when 84 then "Proceed to this location - await instructions"
            when 85 then "Clearance granted - proceed to berth"
            when 86 then "(reserved for future use)"
            when 87 then "(reserved for future use)"
            when 88 then "Information: Pilot boarding position"
            when 89 then "Information: Icebreaker waiting area"
            when 90 then "Information: Places of refuge"
            when 91 then "Information: Position of icebreakers"
            when 92 then "Information: Location of response units"
            when 93 then "VTS active target"
            when 94 then "Rogue or suspicious vessel"
            when 95 then "Vessel requesting non-distress assistance"
            when 96 then "Chart Feature: Sunken vessel"
            when 97 then "Chart Feature: Submerged object"
            when 98 then "Chart Feature:Semi-submerged object"
            when 99 then "Chart Feature: Shoal area"
            when 100 then "Chart Feature: Shoal area due north"
            when 101 then "Chart Feature: Shoal area due east"
            when 102 then "Chart Feature: Shoal area due south"
            when 103 then "Chart Feature: Shoal area due west"
            when 104 then "Chart Feature: Channel obstruction"
            when 105 then "Chart Feature: Reduced vertical clearance"
            when 106 then "Chart Feature: Bridge closed"
            when 107 then "Chart Feature: Bridge partially open"
            when 108 then "Chart Feature: Bridge fully open"
            when 109 then "(reserved for future use)"
            when 110 then "(reserved for future use)"
            when 111 then "(reserved for future use)"
            when 112 then "Report from ship: Icing info"
            when 113 then "(reserved for future use)"
            when 114 then "Report from ship: Miscellaneous information - define in associated text field"
            when 115 then "(reserved for future use)"
            when 116 then "(reserved for future use)"
            when 117 then "(reserved for future use)"
            when 118 then "(reserved for future use)"
            when 119 then "(reserved for future use)"
            when 120 then "Route: Recommended route"
            when 121 then "Route: Alternative route"
            when 122 then "Route: Recommended route through ice"
            when 123 then "(reserved for future use)"
            when 124 then "(reserved for future use)"
            when 125 then "Other - Define in associated text field"
            when 126 then "Cancellation - cancel area as identified by Message Linkage ID"
            when 127 then "Undefined (default)"
            end
          end

          # @!parse attr_reader :utc_time
          # @return [Time] utc time
          def utc_time
            month  = _u(73, 4)
            day    = _u(77, 5)
            hour   = _u(82, 5)
            minute = _u(87, 6)
            _get_date_mdhm(month, day, hour, minute)
          end

          payload_reader :duration, 93, 18, :_u, 262_143

          # Sub-areas defined by this message
          # @return [Array] An array of {SubArea} objects
          attr_accessor :sub_areas

          # @!parse attr_reader :sub_area_text
          # @return [String] The concatenated text of all subarea texts
          def sub_area_text
            texts = sub_areas.select { |a| a.shape_id == 5 }
            return nil if texts.empty?
            texts.collect(&:text).join
          end

        end
      end
    end
  end
end
