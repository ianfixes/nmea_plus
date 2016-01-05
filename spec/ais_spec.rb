require 'nmea_plus'

RSpec.describe NMEAPlus::Decoder, "#parse" do
  describe "testing the parser" do
    before do
      @parser = NMEAPlus::Decoder.new
    end

    epsilon = 0.0000001

    # validated against http://www.maritec.co.za/tools/aisvdmvdodecoding/

    context "when reading an AIS message" do
      it "conforms to basic NMEA features" do
        input = "!AIVDM,1,1,,B,15NO=ndP01JrjhlH@0s;3?vD0L0e,0*77"
        parsed = @parser.parse(input)
        expect(parsed.talker).to eq("AI")
        expect(parsed.message_type).to eq("VDM")
      end
    end

    context "when reading a VDM message" do
      it "properly detects the armored payload" do
        input = "!AIVDM,1,1,,B,15NO=ndP01JrjhlH@0s;3?vD0L0e,0*77"
        parsed = @parser.parse(input)
        expect(parsed.full_armored_ais_payload).to eq("15NO=ndP01JrjhlH@0s;3?vD0L0e")
        expect(parsed.ais.message_type).to eq(1)
      end
    end

    context "when dealing with VDM payload data" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,15NO=ndP01JrjhlH@0s;3?vD0L0e,0*77"
        parsed = @parser.parse(input)
        expect(parsed._dearmor6b("0")).to eq("000000")
        expect(parsed._dearmor6b("W")).to eq("100111")
        expect(parsed._dearmor6b("`")).to eq("101000")
        expect(parsed._dearmor6b("w")).to eq("111111")
      end
    end

    context "when dealing with a decoded payload" do
      def test_payload(message, field_length, method_name, input, expected)
        message.payload_bitstring = input.to_s(2).rjust(field_length, "0")
        calculated = message.send(method_name, 0, field_length)
        expect(calculated).to eq(expected)
      end

      [0, 1, 2, 127, 128, 129, 254, 255].each do |input|
        it "properly decodes 8-bit #{input.to_s(2).rjust(8, "0")} as an unsigned integer" do
          m = NMEAPlus::Message::AIS::VDMPayload::VDMMsg.new
          test_payload(m, 8, :_u, input, input)
        end
      end

      [[0, 0], [1, 1], [2, 2], [127, 127], [128, -128], [129, -127], [254, -2], [255, -1]].each do |input, expected|
        it "properly decodes 8-bit #{input.to_s(2).rjust(8, "0")} as a signed integer" do
          m = NMEAPlus::Message::AIS::VDMPayload::VDMMsg.new
          test_payload(m, 8, :_i, input, expected)
        end
      end
    end

    context "when reading a multipart VDM message" do
      it "properly decodes the armored payload" do
        input1 = "!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E"
        input2 = "!AIVDM,2,2,3,B,1@0000000000000,2*55"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        expect(parsed.full_armored_ais_payload).to eq("55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E531@0000000000000")
        expect(parsed.last_ais_fill_bits).to eq(2)

        expect(parsed.ais.message_type).to eq(5)
        expect(parsed.ais.repeat_indicator).to eq(0)
      end
    end

    context "when dealing with VDM payload data message type 1,2,3" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,15NO=ndP01JrjhlH@0s;3?vD0L0e,0*77"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(1)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(367513050)
        expect(parsed.ais.navigational_status).to eq(12)
        expect(parsed.ais.navigational_status_description).to eq("Reserved for future use")
        expect(parsed.ais.rate_of_turn).to eq(nil)
        expect(parsed.ais.speed_over_ground).to eq(0.1)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-71.04251666666667)
        expect(parsed.ais.latitude).to be_within(epsilon).of(42.380340000000004)
        expect(parsed.ais.course_over_ground).to eq(282.8)
        expect(parsed.ais.true_heading).to eq(nil)
        expect(parsed.ais.time_stamp).to eq(10)
        expect(parsed.ais.special_manoeuvre).to eq(0)
        expect(parsed.ais.raim?).to eq(false)
      end
    end

    context "when reading a VDM message type 4" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,403OK@Quw35W<rsg:hH:wK70087D,0*6E"
        parsed = @parser.parse(input)

        expect(parsed.ais.message_type).to eq(4)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq("003660610".to_i)
        expect(parsed.ais.current_time).to eq(Time.new(2015, 12, 6, 5, 39, 12))
        expect(parsed.ais.position_10m_accuracy?).to eq(true)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-70.83633333333334)
        expect(parsed.ais.latitude).to be_within(epsilon).of(42.24316666666667)
        expect(parsed.ais.epfd_type).to eq(7)
        expect(parsed.ais.raim?).to eq(false)
      end
    end

    context "when reading a multipart VDM message type 5" do
      it "properly decodes the armored payload" do
        input1 = "!AIVDM,2,1,0,A,58wt8Ui`g??r21`7S=:22058<v05Htp000000015>8OA;0sk,0*7B"
        input2 = "!AIVDM,2,2,0,A,eQ8823mDm3kP00000000000,2*5D"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        now = Time.now

        expect(parsed.ais.message_type).to eq(5)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(603916439)
        expect(parsed.ais.ais_version).to eq(0)
        expect(parsed.ais.imo_number).to eq(439303422)
        expect(parsed.ais.callsign.strip).to eq("ZA83R")
        expect(parsed.ais.name.strip).to eq("ARCO AVON")
        expect(parsed.ais.ship_cargo_type).to eq(69)
        expect(parsed.ais.ship_dimension_to_bow).to eq(113)
        expect(parsed.ais.ship_dimension_to_stern).to eq(31)
        expect(parsed.ais.ship_dimension_to_port).to eq(17)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(11)
        expect(parsed.ais.epfd_type).to eq(0)
        expect(parsed.ais.eta).to eq(Time.new(now.year, 3, 23, 19, 45, 0))
        expect(parsed.ais.static_draught).to eq(13.2)
        expect(parsed.ais.destination.strip).to eq("HOUSTON")
        expect(parsed.ais.dte?).to eq(false)
      end
    end

    context "when dealing with VDM payload data message type 8" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,85PnJ9QKf3jT:tSC1W9fQuad7t?>rGW9>j?id9cbot:uO10c5Nj7,0*4A"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(8)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(369990182)
        expect(parsed.ais.designated_area_code).to eq(366)
        expect(parsed.ais.functional_id).to eq(56)
        expect(parsed.ais.application_data_6b).to eq("OJP+2MLF\\&:G6&0_0<;)^\\$;H?F0&.+_0+5<DB,U;HG")
      end
    end

    context "when dealing with VDM payload data message type 14" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,>>M4fWA<59B1@E=@,0*17"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(14)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(970010269)
        expect(parsed.ais.text).to eq("SART TEST")
      end
    end

    context "when dealing with VDM payload data message type 18" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,B5NLCa000>fdwc63f?aBKwPUoP06,0*15"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(18)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(367465380)
        expect(parsed.ais.speed_over_ground).to eq(0.0)
        expect(parsed.ais.position_10m_accuracy?).to eq(true)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-71.03836333333334)
        expect(parsed.ais.latitude).to be_within(epsilon).of(42.34964333333333)
        expect(parsed.ais.course_over_ground).to be_within(epsilon).of(131.8)
        expect(parsed.ais.true_heading).to eq(nil)
        expect(parsed.ais.time_stamp).to eq(1)
        # above here is common with type 19
        expect(parsed.ais.cs_unit?).to eq(true)
        expect(parsed.ais.display?).to eq(false)
        expect(parsed.ais.dsc?).to eq(true)
        expect(parsed.ais.band?).to eq(true)
        expect(parsed.ais.accept_message_22?).to eq(true)
        expect(parsed.ais.assigned?).to eq(false)
        expect(parsed.ais.raim?).to eq(true)
      end
    end


    context "when dealing with VDM payload data message type 19" do
      it "properly decodes the armored payload" do
        input1 = "!AIVDM,2,1,0,B,C8u:8C@t7@TnGCKfm6Po`e6N`:Va0L2J;06HV50JV?SjBPL3,0*28"
        input2 = "!AIVDM,2,2,0,B,11RP,0*17"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        expect(parsed.ais.message_type).to eq(19)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(601000013)
        expect(parsed.ais.speed_over_ground).to eq(2.9)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(32.19953)
        expect(parsed.ais.latitude).to be_within(epsilon).of(-29.837480000000003)
        expect(parsed.ais.course_over_ground).to eq(89)
        expect(parsed.ais.true_heading).to eq(90)
        expect(parsed.ais.time_stamp).to eq(12)
        expect(parsed.ais.name).to eq("TEST NAME CLSB MSG19")
        expect(parsed.ais.ship_cargo_type).to eq(37)
        expect(parsed.ais.ship_cargo_type_description).to eq("Pleasure craft")
        expect(parsed.ais.ship_dimension_to_bow).to eq(7)
        expect(parsed.ais.ship_dimension_to_stern).to eq(6)
        expect(parsed.ais.ship_dimension_to_port).to eq(2)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(3)
        expect(parsed.ais.epfd_type).to eq(1)
        expect(parsed.ais.raim?).to eq(false)
        expect(parsed.ais.dte?).to eq(true)
        expect(parsed.ais.assigned?).to eq(false)
      end
    end


    context "when dealing with VDM payload data message type 20" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,D03OK@QclNfp00N007pf9H80v9H,2*33"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(20)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq("003660610".to_i)
        expect(parsed.ais.offset1).to eq(1725)
        expect(parsed.ais.reserved_slots1).to eq(1)
        expect(parsed.ais.timeout1).to eq(7)
        expect(parsed.ais.increment1).to eq(750)
        expect(parsed.ais.offset2).to eq(0)
        expect(parsed.ais.reserved_slots2).to eq(1)
        expect(parsed.ais.timeout2).to eq(7)
        expect(parsed.ais.increment2).to eq(0)
        expect(parsed.ais.offset3).to eq(126)
        expect(parsed.ais.reserved_slots3).to eq(2)
        expect(parsed.ais.timeout3).to eq(7)
        expect(parsed.ais.increment3).to eq(150)
        expect(parsed.ais.offset4).to eq(128)
        expect(parsed.ais.reserved_slots4).to eq(3)
        expect(parsed.ais.timeout4).to eq(7)
        expect(parsed.ais.increment4).to eq(150)
      end
    end

    context "when dealing with VDM payload data message type 21" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,ENk`sR9`92ah97PR9h0W1T@1@@@=MTpS<7GFP00003vP000,2*4B"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(21)
        expect(parsed.ais.repeat_indicator).to eq(1)
        expect(parsed.ais.source_mmsi).to eq(993672072)
        expect(parsed.ais.aid_type).to eq(19)
        expect(parsed.ais.name.strip).to eq("PRES ROADS ANCH B")
        expect(parsed.ais.name_extension.strip).to eq("")
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-70.96399500000001)
        expect(parsed.ais.latitude).to be_within(epsilon).of(42.34526)
        expect(parsed.ais.ship_dimension_to_bow).to eq(0)
        expect(parsed.ais.ship_dimension_to_stern).to eq(0)
        expect(parsed.ais.ship_dimension_to_port).to eq(0)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(0)
        expect(parsed.ais.epfd_type).to eq(7)
        expect(parsed.ais.time_stamp).to eq(61)
        expect(parsed.ais.off_position?).to eq(false)
        expect(parsed.ais.raim?).to eq(false)
        expect(parsed.ais.virtual_aid?).to eq(false)
        expect(parsed.ais.assigned?).to eq(false)
      end

      it "properly decodes a mulitpart armored payload" do
        input1 = "!AIVDM,2,1,5,B,E1c2;q@b44ah4ah0h:2ab@70VRpU<Bgpm4:gP50HH`Th`QF5,0*7B"
        input2 = "!AIVDM,2,2,5,B,1CQ1A83PCAH0,0*60"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        expect(parsed.ais.message_type).to eq(21)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(112233445)
        expect(parsed.ais.aid_type).to eq(1)
        expect(parsed.ais.name.strip).to eq("THIS IS A TEST NAME1")
        expect(parsed.ais.name_extension.strip).to eq("EXTENDED NAME")
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(145.181)
        expect(parsed.ais.latitude).to be_within(epsilon).of(-38.220166666666664)
        expect(parsed.ais.ship_dimension_to_bow).to eq(5)
        expect(parsed.ais.ship_dimension_to_stern).to eq(3)
        expect(parsed.ais.ship_dimension_to_port).to eq(3)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(5)
        expect(parsed.ais.epfd_type).to eq(1)
        expect(parsed.ais.time_stamp).to eq(9)
        expect(parsed.ais.off_position?).to eq(true)
        expect(parsed.ais.raim?).to eq(false)
        expect(parsed.ais.virtual_aid?).to eq(false)
        expect(parsed.ais.assigned?).to eq(true)
      end
    end

    context "when dealing with VDM payload data message type 24" do
      it "properly decodes the armored payload for part A" do
        input = "!AIVDM,1,1,,B,H5NLCa0JuJ0U8tr0l4T@Dp00000,2*1C"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(24)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(367465380)
        expect(parsed.ais.part_number).to eq(0)
        expect(parsed.ais.name).to eq("F/V IRON MAIDEN")
      end

      it "properly decodes the armored payload for part B" do
        input = "!AIVDM,1,1,,B,H5NLCa4NCD=6mTDG46mnji000000,0*36"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(24)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(367465380)
        expect(parsed.ais.part_number).to eq(1)
        expect(parsed.ais.ship_cargo_type).to eq(30)
        expect(parsed.ais.vendor_id).to eq("STM")
        expect(parsed.ais.model_code).to eq(1)
        expect(parsed.ais.serial_number).to eq(743700)
        expect(parsed.ais.callsign).to eq("WDF5621")
        expect(parsed.ais.auxiliary_craft?).to eq(false)
        expect(parsed.ais.ship_dimension_to_bow).to eq(0)
        expect(parsed.ais.ship_dimension_to_stern).to eq(0)
        expect(parsed.ais.ship_dimension_to_port).to eq(0)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(0)
        #expect(parsed.ais.mothership_mmsi).to eq(3)
      end

      it "properly decodes another armored payload for part B" do
        input = "!AIVDM,1,1,,B,H1c2;qDTijklmno31<" + "<C970`43<1,0*28" # << is problematic for emacs formatting?
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(24)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(112233445)
        expect(parsed.ais.part_number).to eq(1)
        expect(parsed.ais.ship_cargo_type).to eq(36)
        expect(parsed.ais.ship_cargo_type_description).to eq("Sailing")
        #expect(parsed.ais.vendor_id).to eq("1234567") # as seen in online parser, but spec says only 3 chars
        #expect(parsed.ais.model_code).to eq(1)
        #expect(parsed.ais.serial_number).to eq(743700)
        expect(parsed.ais.vendor_id).to eq("123")
        expect(parsed.ais.callsign).to eq("CALLSIG")
        expect(parsed.ais.auxiliary_craft?).to eq(false)
        expect(parsed.ais.ship_dimension_to_bow).to eq(5)
        expect(parsed.ais.ship_dimension_to_stern).to eq(4)
        expect(parsed.ais.ship_dimension_to_port).to eq(3)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(12)
      end
    end

    context "when dealing with VDM payload data message type 27" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,KC5E2b@U19PFdLbMuc5=ROv62<7m,0*16"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(27)
        expect(parsed.ais.repeat_indicator).to eq(1)
        expect(parsed.ais.source_mmsi).to eq(206914217)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.raim?).to eq(false)
        expect(parsed.ais.navigational_status).to eq(2)
        expect(parsed.ais.navigational_status_description).to eq("Not under command")
        expect(parsed.ais.longitude).to be_within(epsilon).of(137.02333333333334)
        expect(parsed.ais.latitude).to be_within(epsilon).of(4.84)
        expect(parsed.ais.speed_over_ground).to eq(57)
        expect(parsed.ais.course_over_ground).to eq(167)
        expect(parsed.ais.gnss?).to eq(false)
      end
    end

    context "when parsing a list of real messages" do
      it "recognizes all of them" do
        samples = File.join(File.dirname(__FILE__), "samples", "aivdm_message_samples.txt")
        File.readlines(samples).each do |line|
          parsed = @parser.parse(line)
          expect(parsed.is_a? NMEAPlus::Message::AIS::AISMessage).to eq(true)
          expect(parsed.is_a? NMEAPlus::Message::Base).to eq(true)
          if parsed.checksum_ok?
            expect(parsed.ais.message_type.is_a? Integer).to eq(true)
            if parsed.message_number == 1 && parsed.ais.is_a?(NMEAPlus::Message::AIS::VDMPayload::VDMMsgUndefined)
              puts "AIS message type #{parsed.ais.message_type} isn't fleshed out: #{parsed.original}"
            end
          end
        end
      end
    end


  end
end
