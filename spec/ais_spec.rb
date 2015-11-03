require 'nmea_plus'

RSpec.describe NMEAPlus::Decoder, "#parse" do
  describe "testing the parser" do
    before do
      @parser = NMEAPlus::Decoder.new
    end

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
        expect(parsed.full_armored_payload).to eq("15NO=ndP01JrjhlH@0s;3?vD0L0e")
        expect(parsed.payload.message_type).to eq(1)
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


    context "when reading a multipart VDM message" do
      it "properly decodes the armored payload" do
        input1 = "!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E"
        input2 = "!AIVDM,2,2,3,B,1@0000000000000,2*55"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        expect(parsed.full_armored_payload).to eq("55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E531@0000000000000")
        expect(parsed.last_fill_bits).to eq(2)

        expect(parsed.payload.message_type).to eq(5)
        expect(parsed.payload.repeat_indicator).to eq(0)
      end
    end

    context "when reading a multipart VDM message type 5" do
      it "properly decodes the armored payload" do
        input1 = "!AIVDM,2,1,0,A,58wt8Ui`g??r21`7S=:22058<v05Htp000000015>8OA;0sk,0*7B"
        input2 = "!AIVDM,2,2,0,A,eQ8823mDm3kP00000000000,2*5D"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        now = Time.now

        expect(parsed.payload.message_type).to eq(5)
        expect(parsed.payload.repeat_indicator).to eq(0)
        expect(parsed.payload.source_mmsi).to eq(603916439)
        expect(parsed.payload.ais_version).to eq(0)
        expect(parsed.payload.imo_number).to eq(439303422)
        expect(parsed.payload.callsign.strip).to eq("ZA83R")
        expect(parsed.payload.name.strip).to eq("ARCO AVON")
        expect(parsed.payload.ship_cargo_type).to eq(69)
        expect(parsed.payload.ship_dimension_to_bow).to eq(113)
        expect(parsed.payload.ship_dimension_to_stern).to eq(31)
        expect(parsed.payload.ship_dimension_to_port).to eq(17)
        expect(parsed.payload.ship_dimension_to_starboard).to eq(11)
        expect(parsed.payload.epfd_type).to eq(0)
        expect(parsed.payload.eta).to eq(Time.new(now.year, 3, 23, 19, 45, 0))
        expect(parsed.payload.static_draught).to eq(13.2)
        expect(parsed.payload.destination.strip).to eq("HOUSTON")
        expect(parsed.payload.dte?).to eq(false)
      end
    end

    context "when dealing with VDM payload data message type 1,2,3" do
      it "properly decodes the armored payload" do
        input = "!AIVDM,1,1,,B,15NO=ndP01JrjhlH@0s;3?vD0L0e,0*77"
        parsed = @parser.parse(input)
        expect(parsed.payload.message_type).to eq(1)
        expect(parsed.payload.repeat_indicator).to eq(0)
        expect(parsed.payload.source_mmsi).to eq(367513050)
        expect(parsed.payload.navigational_status).to eq(12)
        expect(parsed.payload.rate_of_turn).to eq(nil)
        expect(parsed.payload.speed_over_ground).to eq(0.1)
        expect(parsed.payload.position_10m_accuracy?).to eq(false)
        expect(parsed.payload.longitude).to eq(-71.04251666666667)
        expect(parsed.payload.latitude).to eq(42.380340000000004)
        expect(parsed.payload.course_over_ground).to eq(282.8)
        expect(parsed.payload.true_heading).to eq(nil)
        expect(parsed.payload.time_stamp).to eq(10)
        expect(parsed.payload.special_manoeuvre).to eq(0)
        expect(parsed.payload.raim?).to eq(false)
      end
    end



  end
end
