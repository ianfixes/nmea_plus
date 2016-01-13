require 'nmea_plus'

RSpec.describe NMEAPlus::Decoder, "#parse" do
  describe "testing the parser" do
    before do
      @parser = NMEAPlus::Decoder.new
    end

    epsilon = 0.0000001

    # some test cases from https://github.com/schwehr/libais/blob/master/test/data/test.aivdm
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

      # Unsigned integers: x == x ?
      [0, 1, 2, 127, 128, 129, 254, 255].each do |input|
        it "properly decodes 8-bit #{input.to_s(2).rjust(8, "0")} as an unsigned integer" do
          m = NMEAPlus::Message::AIS::VDMPayload::VDMMsg.new
          test_payload(m, 8, :_u, input, input)
        end
      end

      # signed integers: x == y ?
      [[0, 0], [1, 1], [2, 2], [127, 127], [128, -128], [129, -127], [254, -2], [255, -1]].each do |input, expected|
        it "properly decodes 8-bit #{input.to_s(2).rjust(8, "0")} as a signed integer" do
          m = NMEAPlus::Message::AIS::VDMPayload::VDMMsg.new
          test_payload(m, 8, :_i, input, expected)
        end
      end

      # allow us to just mangle the MMSI for testing
      class TestMessage < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
        attr_accessor :source_mmsi
      end

      # MMSI, expected MID, and description
      [
       [367447520, 367, "Individual ship"],
       [  5551123, 555, "Coast station"], # leading zeros don't work here
       [  6662234, 666, "Harbor station"],
       [  7773345, 777, "Pilot station"],
       [  8884456, 888, "AIS repeater station"],
       [111345000, 345, "SAR aircraft"],
       [111456100, 456, "SAR fixed-wing aircraft"],
       [111567500, 567, "SAR helicopter"],
       [812111111, 121, "Handheld transceiver"],
       [970131111, 131, "AIS-SART"],
       [972141111, 141, "MOB (Man Overboard)"],
       [974151111, 151, "EPIRB"],
       [981611111, 161, "Auxiliary craft"],
       [993231000, 323, "Physical AIS AtoN"],
       [993436000, 343, "Virtual AIS AtoN"],
       [993534000, 353, "AIS Aid to Navigation"],
       [900000000, nil, "unknown_mmsi_category"],
      ].each do |code, mid, description|
        it "properly determines the category of MMSI #{code}" do
          m = TestMessage.new
          m.source_mmsi = code
          expect(m.mmsi_category_description).to eq(description)
          expect(m.mid).to eq(mid)
        end
      end

      # MMSI/MID region, ISO country code
      [[201, 8],
       [351, 591],
       [354, 591],
       [370, 591],
       [373, 591],
       [366, 840],
       [369, 840],
      ].each do |mid, country|
        it "properly determines the country code for MID #{mid}" do
          m = TestMessage.new
          m.source_mmsi = "#{mid}000000"
          expect(m.mid_country).to eq(country)
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

    context "when dealing with VDM payload data message type 1" do
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

      it "properly decodes the armored payload libais #4" do
        input = "!AIVDM,1,1,,A,15B4FT5000JRP>PE6E68Nbkl0PS5,0*70"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(1)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(354490000)
        expect(parsed.ais.navigational_status).to eq(5)
        expect(parsed.ais.navigational_status_description).to eq("Moored")
        expect(parsed.ais.rate_of_turn).to eq(0)
        expect(parsed.ais.speed_over_ground).to eq(0.0)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-76.34866666666667)
        expect(parsed.ais.latitude).to be_within(epsilon).of(36.873)
        expect(parsed.ais.course_over_ground).to eq(217)
        expect(parsed.ais.true_heading).to eq(345)
        expect(parsed.ais.time_stamp).to eq(58)
        expect(parsed.ais.special_manoeuvre).to eq(0)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #6" do
        input = "!AIVDM,1,1,,B,15Mw1U?P00qNGTP@v`0@9wwn26sd,0*0E"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(1)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(366985620)
        expect(parsed.ais.navigational_status).to eq(15)
        expect(parsed.ais.navigational_status_description).to eq("Not defined")
        expect(parsed.ais.rate_of_turn).to eq(nil)
        expect(parsed.ais.speed_over_ground).to eq(0.0)
        expect(parsed.ais.position_10m_accuracy?).to eq(true)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-91.23304)
        expect(parsed.ais.latitude).to be_within(epsilon).of(29.672108333333334)
        expect(parsed.ais.course_over_ground).to eq(3.9)
        expect(parsed.ais.true_heading).to eq(nil)
        expect(parsed.ais.time_stamp).to eq(59)
        expect(parsed.ais.special_manoeuvre).to eq(0)
        expect(parsed.ais.raim?).to eq(true)
      end

      it "properly decodes the armored payload libais #8" do
        input = "!AIVDM,1,1,,B,15N5s90P00IB>dtA7f<pOwv00<1a,0*2B"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(1)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(367098660)
        expect(parsed.ais.navigational_status).to eq(0)
        expect(parsed.ais.navigational_status_description).to eq("Under way using engine")
        expect(parsed.ais.rate_of_turn).to eq(nil)
        expect(parsed.ais.speed_over_ground).to eq(0)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-93.88475)
        expect(parsed.ais.latitude).to be_within(epsilon).of(29.920511666666666)
        expect(parsed.ais.course_over_ground).to eq(217.5)
        expect(parsed.ais.true_heading).to eq(nil)
        expect(parsed.ais.time_stamp).to eq(0)
        expect(parsed.ais.special_manoeuvre).to eq(0)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #10" do
        input = "!AIVDM,1,1,,B,15Mq4J0P01EREODRv4@74gv00HRq,0*72"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(1)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(366888040)
        expect(parsed.ais.navigational_status).to eq(0)
        expect(parsed.ais.navigational_status_description).to eq("Under way using engine")
        expect(parsed.ais.rate_of_turn).to eq(nil)
        expect(parsed.ais.speed_over_ground).to eq(0.1)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-146.29038333333332)
        expect(parsed.ais.latitude).to be_within(epsilon).of(61.114133333333335)
        expect(parsed.ais.course_over_ground).to eq(181)
        expect(parsed.ais.true_heading).to eq(nil)
        expect(parsed.ais.time_stamp).to eq(0)
        expect(parsed.ais.special_manoeuvre).to eq(0)
        expect(parsed.ais.raim?).to eq(false)
      end

    end

    context "when dealing with VDM payload data message type 2" do
      it "properly decodes the armored payload libais #13" do
        input = "!AIVDM,1,1,,B,25Mw@DP000qR9bFA:6KI0AV@00S3,0*0A"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(2)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(366989394)
        expect(parsed.ais.navigational_status).to eq(0)
        expect(parsed.ais.rate_of_turn).to eq(0.0)
        expect(parsed.ais.speed_over_ground).to eq(0.0)
        expect(parsed.ais.position_10m_accuracy?).to eq(true)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-90.40670166666666)
        expect(parsed.ais.latitude).to be_within(epsilon).of(29.985461666666666)
        expect(parsed.ais.course_over_ground).to eq(230.5)
        expect(parsed.ais.true_heading).to eq(51)
        expect(parsed.ais.time_stamp).to eq(8)
        expect(parsed.ais.special_manoeuvre).to eq(0)
        expect(parsed.ais.raim?).to eq(false)
      end
    end

    context "when dealing with VDM payload data message type 3" do
      it "properly decodes the armored payload libais #16" do
        input = "!AIVDM,1,1,,B,35MC>W@01EIAn5VA4l`N2;>0015@,0*01"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(3)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(366268061)
        expect(parsed.ais.navigational_status).to eq(0)
        expect(parsed.ais.rate_of_turn).to eq(0)
        expect(parsed.ais.speed_over_ground).to eq(8.5)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-93.96876833333333)
        expect(parsed.ais.latitude).to be_within(epsilon).of(29.841335)
        expect(parsed.ais.course_over_ground).to eq(359.2)
        expect(parsed.ais.true_heading).to eq(359)
        expect(parsed.ais.time_stamp).to eq(0)
        expect(parsed.ais.special_manoeuvre).to eq(0)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #18" do
        input = "!AIVDM,1,1,,A,35NBTh0Oh1G@Dt8EiccBuE3n00nQ,0*05"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(3)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(367305920)
        expect(parsed.ais.navigational_status).to eq(0)
        expect(parsed.ais.rate_of_turn).to eq(720.0032105295371)
        expect(parsed.ais.speed_over_ground).to eq(0.1)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-122.26239333333334)
        expect(parsed.ais.latitude).to be_within(epsilon).of(38.056821666666664)
        expect(parsed.ais.course_over_ground).to eq(75.7)
        expect(parsed.ais.true_heading).to eq(161)
        expect(parsed.ais.time_stamp).to eq(59)
        expect(parsed.ais.special_manoeuvre).to eq(0)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #20" do
        input = "!AIVDM,1,1,,B,35N0IFP016Jf9rVG8mSB?Acl0Pj0,0*4C"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(3)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(367008090)
        expect(parsed.ais.navigational_status).to eq(0)
        expect(parsed.ais.rate_of_turn).to eq(0)
        expect(parsed.ais.speed_over_ground).to eq(7)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-73.80338166666667)
        expect(parsed.ais.latitude).to be_within(epsilon).of(40.436715)
        expect(parsed.ais.course_over_ground).to eq(57.3)
        expect(parsed.ais.true_heading).to eq(53)
        expect(parsed.ais.time_stamp).to eq(58)
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

      it "properly decodes the armored payload libais #25" do
        input = "!AIVDM,1,1,,A,402u=TiuaA000r5UJ`H4`?7000S:,0*75"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(4)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq("003100051".to_i)
        expect(parsed.ais.current_time).to eq(Time.new(2010, 5, 2, 0, 0, 0))
        expect(parsed.ais.position_10m_accuracy?).to eq(true)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-82.6661)
        expect(parsed.ais.latitude).to be_within(epsilon).of(42.069433333333336)
        expect(parsed.ais.epfd_type).to eq(7)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #26" do
        input = "!AIVDM,1,1,,A,403OweAuaAGssGWDABBdKBA006sd,0*07"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(4)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq("003669941".to_i)
        expect(parsed.ais.current_time).to eq(Time.new(2010, 5, 2, 23, 59, 59))
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-117.24025166666667)
        expect(parsed.ais.latitude).to be_within(epsilon).of(32.670415)
        expect(parsed.ais.epfd_type).to eq(1)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #27" do
        input = "!AIVDM,1,1,,B,4h3OvjAuaAGsro=cf0Knevo00`S8,0*7E"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(4)
        expect(parsed.ais.repeat_indicator).to eq(3)
        expect(parsed.ais.source_mmsi).to eq("003669705".to_i)
        expect(parsed.ais.current_time).to eq(Time.new(2010, 5, 2, 23, 59, 58))
        expect(parsed.ais.position_10m_accuracy?).to eq(true)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-122.84)
        expect(parsed.ais.latitude).to be_within(epsilon).of(48.68009833333333)
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
        expect(parsed.ais.ship_cargo_type_description).to eq("Passenger, No additional information")
        expect(parsed.ais.ship_dimension_to_bow).to eq(113)
        expect(parsed.ais.ship_dimension_to_stern).to eq(31)
        expect(parsed.ais.ship_dimension_to_port).to eq(17)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(11)
        expect(parsed.ais.epfd_type).to eq(0)
        expect(parsed.ais.eta).to eq(Time.new(now.year, 3, 23, 19, 45, 0))
        expect(parsed.ais.static_draught).to eq(13.2)
        expect(parsed.ais.destination.strip).to eq("HOUSTON")
        expect(parsed.ais.dte_ready?).to eq(true)
      end

      it "properly decodes the armored payload libais #30" do
        input1 = "!AIVDM,2,1,3,B,55NBjP01mtGIL@CW;SM<D60P5Ld000000000000P0`<3557l0<50@kk@,0*66"
        input2 = "!AIVDM,2,2,3,B,K5h@00000000000,2*72"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        now = Time.now
        expect(parsed.ais.message_type).to eq(5)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(367309440)
        expect(parsed.ais.ais_version).to eq(0)
        expect(parsed.ais.imo_number).to eq(7729526)
        expect(parsed.ais.callsign.strip).to eq("WDD9287")
        expect(parsed.ais.name.strip).to eq("SEA HAWK")
        expect(parsed.ais.ship_cargo_type).to eq(32)
        expect(parsed.ais.ship_cargo_type_description).to eq("Towing (large)")
        expect(parsed.ais.ship_dimension_to_bow).to eq(5)
        expect(parsed.ais.ship_dimension_to_stern).to eq(12)
        expect(parsed.ais.ship_dimension_to_port).to eq(3)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(5)
        expect(parsed.ais.epfd_type).to eq(1)
        expect(parsed.ais.eta).to eq(Time.new(now.year, 4, 15, 20, 0, 0))
        expect(parsed.ais.static_draught).to eq(4.8)
        expect(parsed.ais.destination.strip).to eq("TACOMA,WA")
        expect(parsed.ais.dte_ready?).to eq(true)
      end

      it "properly decodes the armored payload libais #32" do
        input1 = "!AIVDM,2,1,1,A,55>u@H02;lGc<Ha;L0084i<7GR22222222222216:PE885AU0A4l13H13kBC,0*3D"
        input2 = "!AIVDM,2,2,1,A,R@hC`4QD;`0,2*06"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        now = Time.now
        expect(parsed.ais.message_type).to eq(5)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(351228000)
        expect(parsed.ais.ais_version).to eq(0)
        expect(parsed.ais.imo_number).to eq(9163130)
        expect(parsed.ais.callsign.strip).to eq("3FJR7")
        expect(parsed.ais.name.strip).to eq("BALSA58")
        expect(parsed.ais.ship_cargo_type).to eq(70)
        expect(parsed.ais.ship_cargo_type_description).to eq("Cargo")
        expect(parsed.ais.ship_dimension_to_bow).to eq(84)
        expect(parsed.ais.ship_dimension_to_stern).to eq(21)
        expect(parsed.ais.ship_dimension_to_port).to eq(8)
        expect(parsed.ais.ship_dimension_to_starboard).to eq(8)
        expect(parsed.ais.epfd_type).to eq(1)
        expect(parsed.ais.eta).to eq(Time.new(now.year, 5, 3, 5, 0, 0))
        expect(parsed.ais.static_draught).to eq(6.8)
        expect(parsed.ais.destination.strip).to eq("SPDM DOMINICAN REP.")
        expect(parsed.ais.dte_ready?).to eq(true)
      end
    end

    context "when reading a mulipart VDM message type 6" do
      it "properly decodes the armored payload with subtype 235/10" do
        input = "!AIVDM,1,1,,A,6>h8nIT00000>d`vP000@00,2*53"
        parsed = @parser.parse(input)

        expect(parsed.ais.message_type).to eq(6)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(990000742)
        expect(parsed.ais.sequence_number).to eq(1)
        expect(parsed.ais.destination_mmsi).to eq(0)
        expect(parsed.ais.retransmitted?).to eq(false)
        expect(parsed.ais.designated_area_code).to eq(235)
        expect(parsed.ais.functional_id).to eq(10)
        expect(parsed.ais.dp.analog_internal).to eq(12.5)
        expect(parsed.ais.dp.analog_external1).to eq(nil)
        expect(parsed.ais.dp.analog_external2).to eq(nil)
        expect(parsed.ais.dp.racon_status).to eq(0)
        expect(parsed.ais.dp.racon_status_description).to eq("no RACON installed")
        expect(parsed.ais.dp.racon_light_status).to eq(1)
        expect(parsed.ais.dp.racon_light_status_description).to eq("ON")
        expect(parsed.ais.dp.racon_alarm?).to eq(false)
        expect(parsed.ais.dp.digital_input7?).to eq(false)
        expect(parsed.ais.dp.digital_input6?).to eq(false)
        expect(parsed.ais.dp.digital_input5?).to eq(false)
        expect(parsed.ais.dp.digital_input4?).to eq(false)
        expect(parsed.ais.dp.digital_input3?).to eq(false)
        expect(parsed.ais.dp.digital_input2?).to eq(false)
        expect(parsed.ais.dp.digital_input1?).to eq(false)
        expect(parsed.ais.dp.digital_input0?).to eq(false)
      end

      it "properly decodes the armored payload with subtype 235/10 again" do
        input = "!AIVDM,1,1,4,B,6>jR0600V:C0>da4P106P00,2*02"
        parsed = @parser.parse(input)

        expect(parsed.ais.message_type).to eq(6)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(992509976)
        expect(parsed.ais.sequence_number).to eq(0)
        expect(parsed.ais.destination_mmsi).to eq(2500912)
        expect(parsed.ais.retransmitted?).to eq(false)
        expect(parsed.ais.designated_area_code).to eq(235)
        expect(parsed.ais.functional_id).to eq(10)
        expect(parsed.ais.dp.analog_internal).to eq(13.7)
        expect(parsed.ais.dp.analog_external1).to eq(0.05)
        expect(parsed.ais.dp.analog_external2).to eq(0.05)
        expect(parsed.ais.dp.racon_status).to eq(2)
        expect(parsed.ais.dp.racon_status_description).to eq("RACON operational")
        expect(parsed.ais.dp.racon_light_status).to eq(2)
        expect(parsed.ais.dp.racon_light_status_description).to eq("OFF")
        expect(parsed.ais.dp.racon_alarm?).to eq(false)
        expect(parsed.ais.dp.digital_input7?).to eq(false)
        expect(parsed.ais.dp.digital_input6?).to eq(false)
        expect(parsed.ais.dp.digital_input5?).to eq(false)
        expect(parsed.ais.dp.digital_input4?).to eq(false)
        expect(parsed.ais.dp.digital_input3?).to eq(false)
        expect(parsed.ais.dp.digital_input2?).to eq(false)
        expect(parsed.ais.dp.digital_input1?).to eq(false)
        expect(parsed.ais.dp.digital_input0?).to eq(false)
      end

      it "properly decodes the armored payload with subtype 1022/61 (Sealite)" do
        input1 = "!AIVDM,2,1,9,B,61c2;qLPH1m@wsm6ARhp<ji6ATHd<C8f=Bhk>34k;S8i=3To,0*2C"
        input2 = "!AIVDM,2,2,9,B,Djhi=3Di<2pp=34k>4D,2*03"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        expect(parsed.ais.message_type).to eq(6)
        expect(parsed.ais.source_mmsi).to eq(112233445)
        expect(parsed.ais.destination_mmsi).to eq(135792468)
        expect(parsed.ais.retransmitted?).to eq(false)
        expect(parsed.ais.designated_area_code).to eq(1022)
        expect(parsed.ais.functional_id).to eq(61)
        expect(parsed.ais.dp.application_data).to eq("FF,83,FFF,12.5,3813.21497S,14510.84138E")
        expect(parsed.ais.dp.supply_fail?).to eq(true)
        expect(parsed.ais.dp.gps_off_station?).to eq(true)
        expect(parsed.ais.dp.light_sensor_dark?).to eq(true)
        expect(parsed.ais.dp.gps_sync_valid?).to eq(true)
        expect(parsed.ais.dp.gps_valid?).to eq(true)
        expect(parsed.ais.dp.temperature_sensor_hot?).to eq(true)
        expect(parsed.ais.dp.battery_flat?).to eq(true)
        expect(parsed.ais.dp.battery_low?).to eq(true)
        expect(parsed.ais.dp.operation_mode).to eq(2)
        expect(parsed.ais.dp.operation_mode_description).to eq("Always on")
        expect(parsed.ais.dp.intensity_percent).to eq(6.25)
        expect(parsed.ais.dp.flash_code).to eq("FFF".hex)
        expect(parsed.ais.dp.battery_voltage).to eq(12.5)
        expect(parsed.ais.dp.latitude).to be_within(epsilon).of(-38.2202495)
        expect(parsed.ais.dp.longitude).to be_within(epsilon).of(145.18068966666667)
      end

      it "properly decodes the armored payload with subtype 1022/61 (Sealite) again" do
        input1 = "!AIVDM,2,1,1,B,61c2;qLPH1m@wslh>2hm<BhhATHd<CTf=jhk>34k;S8i=3UC,0*65"
        input2 = "!AIVDM,2,2,1,B,;34l=C4h;SPl<C=5,0*47"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        expect(parsed.ais.message_type).to eq(6)
        expect(parsed.ais.source_mmsi).to eq(112233445)
        expect(parsed.ais.destination_mmsi).to eq(135792468)
        expect(parsed.ais.retransmitted?).to eq(false)
        expect(parsed.ais.designated_area_code).to eq(1022)
        expect(parsed.ais.functional_id).to eq(61)
        expect(parsed.ais.dp.application_data).to eq("08,51,0FF,19.7,3813.2149S,14510.8413E")
        expect(parsed.ais.dp.supply_fail?).to eq(false)
        expect(parsed.ais.dp.gps_off_station?).to eq(false)
        expect(parsed.ais.dp.light_sensor_dark?).to eq(false)
        expect(parsed.ais.dp.gps_sync_valid?).to eq(false)
        expect(parsed.ais.dp.gps_valid?).to eq(true)
        expect(parsed.ais.dp.temperature_sensor_hot?).to eq(false)
        expect(parsed.ais.dp.battery_flat?).to eq(false)
        expect(parsed.ais.dp.battery_low?).to eq(false)
        expect(parsed.ais.dp.operation_mode).to eq(1)
        expect(parsed.ais.dp.operation_mode_description).to eq("Standby")
        expect(parsed.ais.dp.intensity_percent).to eq(28.125)
        expect(parsed.ais.dp.flash_code).to eq("0FF".hex)
        expect(parsed.ais.dp.battery_voltage).to eq(19.7)
        expect(parsed.ais.dp.latitude).to be_within(epsilon).of(-38.22024833333333)
        expect(parsed.ais.dp.longitude).to be_within(epsilon).of(145.18068833333334)
      end


    end

    context "when dealing with VDM payload data message type 7" do
      it "properly decodes the armored payload libais #48" do
        input = "!AIVDM,1,1,,A,75Mu6d0P17IP?PfGSC29WOvb0<14,0*61"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(7)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(366954160)
        expect(parsed.ais.ack1_mmsi).to eq(134290840)
        expect(parsed.ais.ack1_sequence_number).to eq(0)
        expect(parsed.ais.ack2_mmsi).to eq(260236771)
        expect(parsed.ais.ack2_sequence_number).to eq(1)
        expect(parsed.ais.ack3_mmsi).to eq(203581311)
        expect(parsed.ais.ack3_sequence_number).to eq(3)
        expect(parsed.ais.ack4_mmsi).to eq(713043985)
        expect(parsed.ais.ack4_sequence_number).to eq(0)
      end

      it "properly decodes the armored payload libais #49" do
        input = "!AIVDM,1,1,,A,7CtgNN000000,0*41"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(7)
        expect(parsed.ais.repeat_indicator).to eq(1)
        expect(parsed.ais.source_mmsi).to eq(265019000)
        expect(parsed.ais.ack1_mmsi).to eq(0)
        expect(parsed.ais.ack1_sequence_number).to eq(0)
        expect(parsed.ais.ack2_mmsi).to eq(nil)
        expect(parsed.ais.ack2_sequence_number).to eq(nil)
        expect(parsed.ais.ack3_mmsi).to eq(nil)
        expect(parsed.ais.ack3_sequence_number).to eq(nil)
        expect(parsed.ais.ack4_mmsi).to eq(nil)
        expect(parsed.ais.ack4_sequence_number).to eq(nil)
      end

      it "properly decodes the armored payload libais #50" do
        input = "!AIVDM,1,1,,A,7CtgNN000000,0*41"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(7)
        expect(parsed.ais.repeat_indicator).to eq(1)
        expect(parsed.ais.source_mmsi).to eq(265019000)
        expect(parsed.ais.ack1_mmsi).to eq(0)
        expect(parsed.ais.ack1_sequence_number).to eq(0)
        expect(parsed.ais.ack2_mmsi).to eq(nil)
        expect(parsed.ais.ack2_sequence_number).to eq(nil)
        expect(parsed.ais.ack3_mmsi).to eq(nil)
        expect(parsed.ais.ack3_sequence_number).to eq(nil)
        expect(parsed.ais.ack4_mmsi).to eq(nil)
        expect(parsed.ais.ack4_sequence_number).to eq(nil)
      end

      it "properly decodes the armored payload libais #51" do
        input = "!AIVDM,1,1,,B,70C<HvRftSLBTtwN4oTg8261,0*02"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(7)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(20125946)
        expect(parsed.ais.ack1_mmsi).to eq(733777348)
        expect(parsed.ais.ack1_sequence_number).to eq(2)
        expect(parsed.ais.ack2_mmsi).to eq(619968388)
        expect(parsed.ais.ack2_sequence_number).to eq(3)
        expect(parsed.ais.ack3_mmsi).to eq(508282888)
        expect(parsed.ais.ack3_sequence_number).to eq(1)
        expect(parsed.ais.ack4_mmsi).to eq(129) # TODO: WHA???
        expect(parsed.ais.ack4_sequence_number).to eq(nil)
      end

      it "properly decodes the armored payload libais #52" do
        input = "!AIVDM,1,1,,A,74eGSe@0owtf,0*4B"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(7)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(316007349)
        expect(parsed.ais.ack1_mmsi).to eq(3669963)
        expect(parsed.ais.ack1_sequence_number).to eq(2)
        expect(parsed.ais.ack2_mmsi).to eq(nil)
        expect(parsed.ais.ack2_sequence_number).to eq(nil)
        expect(parsed.ais.ack3_mmsi).to eq(nil)
        expect(parsed.ais.ack3_sequence_number).to eq(nil)
        expect(parsed.ais.ack4_mmsi).to eq(nil)
        expect(parsed.ais.ack4_sequence_number).to eq(nil)
      end

      it "properly decodes the armored payload libais #53" do
        input = "!AIVDM,1,1,,A,74eG>;h0h=w0,0*48"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(7)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(316001839)
        expect(parsed.ais.ack1_mmsi).to eq(3160048)
        expect(parsed.ais.ack1_sequence_number).to eq(0)
        expect(parsed.ais.ack2_mmsi).to eq(nil)
        expect(parsed.ais.ack2_sequence_number).to eq(nil)
        expect(parsed.ais.ack3_mmsi).to eq(nil)
        expect(parsed.ais.ack3_sequence_number).to eq(nil)
        expect(parsed.ais.ack4_mmsi).to eq(nil)
        expect(parsed.ais.ack4_sequence_number).to eq(nil)
      end
    end

    context "when dealing with VDM payload data message type 8" do
      it "properly decodes the armored payload with subtype 1/31" do
        input = "!AIVDM,1,1,1,B,8>h8nkP0Glr=<hFI0D6??wvlFR06EuOwgwl?wnSwe7wvlOw?sAwwnSGmwvh0,0*17"
        parsed = @parser.parse(input)
        now = Time.now

        expect(parsed.ais.message_type).to eq(8)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(990000846)
        expect(parsed.ais.designated_area_code).to eq(1)
        expect(parsed.ais.functional_id).to eq(31)
        expect(parsed.ais.dp.longitude).to be_within(epsilon).of(171.5985)
        expect(parsed.ais.dp.latitude).to be_within(epsilon).of(12.228299999999999)
        expect(parsed.ais.dp.position_10m_accuracy?).to eq(true)
        expect(parsed.ais.dp.current_time).to eq(nil)
        expect(parsed.ais.dp.wind_speed_average).to eq(nil)
        expect(parsed.ais.dp.wind_speed_gust).to eq(nil)
        expect(parsed.ais.dp.wind_direction).to eq(nil)
        expect(parsed.ais.dp.wind_direction_gust).to eq(nil)

        expect(parsed.ais.dp.air_temperature).to eq(nil)
        expect(parsed.ais.dp.relative_humidity).to eq(nil)
        expect(parsed.ais.dp.dew_point).to eq(nil)
        expect(parsed.ais.dp.air_pressure_hpa).to eq(nil)
        expect(parsed.ais.dp.air_pressure_tendency).to eq(nil)
        expect(parsed.ais.dp.air_pressure_tendency_description).to eq(nil)

        expect(parsed.ais.dp.visibility_greater_than).to eq(false)
        expect(parsed.ais.dp.horizontal_visibility).to eq(nil)
        expect(parsed.ais.dp.water_level).to eq(nil)
        expect(parsed.ais.dp.water_level_tendency).to eq(nil)
        expect(parsed.ais.dp.water_level_tendency_description).to eq(nil)

        expect(parsed.ais.dp.water_current_speed1).to eq(nil)
        expect(parsed.ais.dp.water_current_direction1).to eq(nil)
        expect(parsed.ais.dp.water_current_depth1).to eq(0)

        expect(parsed.ais.dp.water_current_speed2).to eq(nil)
        expect(parsed.ais.dp.water_current_direction2).to eq(nil)
        expect(parsed.ais.dp.water_current_depth2).to eq(nil)

        expect(parsed.ais.dp.water_current_speed3).to eq(nil)
        expect(parsed.ais.dp.water_current_direction3).to eq(nil)
        expect(parsed.ais.dp.water_current_depth3).to eq(nil)

        expect(parsed.ais.dp.wave_height).to eq(25.2)
        expect(parsed.ais.dp.wave_period).to eq(nil)
        expect(parsed.ais.dp.wave_direction).to eq(nil)
        expect(parsed.ais.dp.swell_height).to eq(nil)
        expect(parsed.ais.dp.swell_period).to eq(nil)
        expect(parsed.ais.dp.swell_direction).to eq(nil)
        expect(parsed.ais.dp.sea_state_beaufort).to eq(13)

        expect(parsed.ais.dp.water_temperature).to eq(nil)
        expect(parsed.ais.dp.precipitation_type).to eq(nil)
        expect(parsed.ais.dp.precipitation_description).to eq(nil)
        expect(parsed.ais.dp.salinity).to eq(nil)
        expect(parsed.ais.dp.salinity_sensor_unavailable?).to eq(false)

        expect(parsed.ais.dp.ice_code).to eq(nil)
        expect(parsed.ais.dp.ice_description).to eq(nil)
      end

      it "properly decodes the armored payload with subtype 366/56" do
        input = "!AIVDM,1,1,,B,85PnJ9QKf3jT:tSC1W9fQuad7t?>rGW9>j?id9cbot:uO10c5Nj7,0*4A"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(8)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(369990182)
        expect(parsed.ais.designated_area_code).to eq(366)
        expect(parsed.ais.functional_id).to eq(56)
        expect(parsed.ais.dp.encrypted_data_6b).to eq("OJP+2MLF\\&:G6&0_0<;)^\\$;H?F0&.+_0+5<DB,U;HG")
      end

      it "properly decodes the armored payload with subtype 366/57" do
        input1 = "!AIVDM,2,1,0,B,85Mwqd1KfLeoeN:JUWK=4p6a9n31S5KL4`RM98WgdAu`sNghBsVb8j8VW7Qd,0*72"
        input2 = "!AIVDM,2,2,0,B,W9Oh5rccO@AqMf0P1HUiPLBP3Wbq0TN9j<t,2*60"
        parsed = @parser.parse(input1)
        parsed.add_message_part(@parser.parse(input2))
        expect(parsed.ais.message_type).to eq(8)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(366999984)
        expect(parsed.ais.designated_area_code).to eq(366)
        expect(parsed.ais.functional_id).to eq(57)
        expect(parsed.ais.dp.encrypted_data_6b).to eq("27^58)*V],4S Z$'XLFLU-0R\"I4$\"^>1G6#-:?AK.Z(#H\"Z\\^F2\\%?@W*.-=AG%68B@E\"WFA1J@N^+$BQ8'H3C")
      end

    end

    context "when dealing with VDM payload data message type 9" do
      it "properly decodes the armored payload libais #88" do
        input = "!AIVDM,1,1,,A,90003uhWAcIJe8B;5>rk1D@200Sk,0*7E"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(9)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq("000001015".to_i)
        expect(parsed.ais.altitude_meters).to eq(157)
        expect(parsed.ais.speed_over_ground).to eq(107)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to eq(-92.033265)
        expect(parsed.ais.latitude).to eq(19.366791666666668)
        expect(parsed.ais.course_over_ground).to eq(77.3)
        expect(parsed.ais.time_stamp).to eq(17)
        expect(parsed.ais.dte_ready?).to eq(false)
        expect(parsed.ais.assigned?).to eq(false)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #89" do
        input = "!AIVDM,1,1,,B,900fK5?wh0IJcT>;6GB004h00408,0*76"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(9)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq("000760596".to_i)
        expect(parsed.ais.altitude_meters).to eq(nil)
        expect(parsed.ais.speed_over_ground).to eq(0)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to eq(-92.03860166666666)
        expect(parsed.ais.latitude).to eq(19.397666666666666)
        expect(parsed.ais.course_over_ground).to eq(0)
        expect(parsed.ais.time_stamp).to eq(19)
        expect(parsed.ais.dte_ready?).to eq(true)
        expect(parsed.ais.assigned?).to eq(false)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #90" do
        input = "!AIVDM,1,1,,B,90003t0=00IId12;<O:nrUP20@=h,0*7D"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(9)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq("000001008".to_i)
        expect(parsed.ais.altitude_meters).to eq(52)
        expect(parsed.ais.speed_over_ground).to eq(0)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to eq(-92.25551833333333)
        expect(parsed.ais.latitude).to eq(19.564871666666665)
        expect(parsed.ais.course_over_ground).to eq(177)
        expect(parsed.ais.time_stamp).to eq(22)
        expect(parsed.ais.dte_ready?).to eq(false)
        expect(parsed.ais.assigned?).to eq(false)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #91" do
        input = "!AIVDM,1,1,,A,9002=micijIJhK0;5t5m@V0000S4,0*37"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(9)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(36311)
        expect(parsed.ais.altitude_meters).to eq(431)
        expect(parsed.ais.speed_over_ground).to eq(114)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to eq(-92.02202666666666)
        expect(parsed.ais.latitude).to eq(19.386065)
        expect(parsed.ais.course_over_ground).to eq(134.6)
        expect(parsed.ais.time_stamp).to eq(24)
        expect(parsed.ais.dte_ready?).to eq(true)
        expect(parsed.ais.assigned?).to eq(false)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #92" do
        input = "!AIVDM,1,1,,B,900fK5?wh0IJcT>;6GB009h000S7,0*13"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(9)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(760596)
        expect(parsed.ais.altitude_meters).to eq(nil)
        expect(parsed.ais.speed_over_ground).to eq(0)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to eq(-92.03860166666666)
        expect(parsed.ais.latitude).to eq(19.397666666666666)
        expect(parsed.ais.course_over_ground).to eq(0)
        expect(parsed.ais.time_stamp).to eq(39)
        expect(parsed.ais.dte_ready?).to eq(true)
        expect(parsed.ais.assigned?).to eq(false)
        expect(parsed.ais.raim?).to eq(false)
      end

      it "properly decodes the armored payload libais #93" do
        input = "!AIVDM,1,1,,A,9018lEPPwwIJdp<;6nk55:h00D3w,0*7E"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(9)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(1193046)
        expect(parsed.ais.altitude_meters).to eq(131)
        expect(parsed.ais.speed_over_ground).to eq(nil)
        expect(parsed.ais.position_10m_accuracy?).to eq(false)
        expect(parsed.ais.longitude).to eq(-92.03412333333333)
        expect(parsed.ais.latitude).to eq(19.411113333333333)
        expect(parsed.ais.course_over_ground).to eq(130)
        expect(parsed.ais.time_stamp).to eq(43)
        expect(parsed.ais.dte_ready?).to eq(true)
        expect(parsed.ais.assigned?).to eq(false)
        expect(parsed.ais.raim?).to eq(false)
      end
    end

    context "when dealing with VDM payload data message type 11" do
      it "properly decodes the armored payload libais #105" do
        input = "!AIVDM,1,1,,B,;8IVO`1ua>09pqGjTp?hsa100000,0*48"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(11)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(563716000)
        expect(parsed.ais.current_time).to eq(Time.new(2010, 4, 28, 0, 9, 56))
        expect(parsed.ais.position_10m_accuracy?).to eq(true)
        expect(parsed.ais.longitude).to be_within(epsilon).of(-92.67003333333334)
        expect(parsed.ais.latitude).to be_within(epsilon).of(27.55056666666667)
        expect(parsed.ais.epfd_type).to eq(1)
        expect(parsed.ais.raim?).to eq(false)
      end
    end

    context "when dealing with VDM payload data message type 12" do
      it "properly decodes the armored payload libais #114" do
        input = "!AIVDM,1,1,,A,<5MwpVn0AAup=C7P6B?=Pknnqqqoho0,2*17"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(12)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(366999707)
        expect(parsed.ais.destination_mmsi).to eq(538003422)
        expect(parsed.ais.retransmit?).to eq(false)
        expect(parsed.ais.text).to eq("MSG FROM 366999707")
      end

      it "properly decodes the armored payload libais #117" do
        input = "!AIVDM,1,1,,B,<qnd>q7>IAiurJuMTIgfsid,2*50"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(12)
        expect(parsed.ais.repeat_indicator).to eq(3)
        expect(parsed.ais.source_mmsi).to eq(661327588)
        expect(parsed.ais.destination_mmsi).to eq(865683231)
        expect(parsed.ais.retransmit?).to eq(false)
        expect(parsed.ais.data).to eq(":Z=]$Y/.;1K") # TODO ????
      end

      it "properly decodes the armored payload libais #118" do
        input = "!AIVDM,1,1,,A,<sk:rC7oh;wCNw@,2*4D"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(12)
        expect(parsed.ais.repeat_indicator).to eq(3)
        expect(parsed.ais.source_mmsi).to eq(791853644)
        expect(parsed.ais.destination_mmsi).to eq(1039151092) # ????? TODO THIS IS 10 DIGITS
        expect(parsed.ais.retransmit?).to eq(true)
        expect(parsed.ais.data).to eq("^?D") # TODO ???
      end

      it "properly decodes the armored payload libais #119" do
        input = "!AIVDM,1,1,,B,<?f1OrCbuesc6w5BCUh,2*27"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(12)
        expect(parsed.ais.repeat_indicator).to eq(0)
        expect(parsed.ais.source_mmsi).to eq(1054892009) # TODO: ?????? 10 digits
        expect(parsed.ais.destination_mmsi).to eq(985511866)
        expect(parsed.ais.retransmit?).to eq(true)
        expect(parsed.ais.data).to eq("F?ERS%L")  # TODO ???
      end

      it "properly decodes the armored payload libais #120" do
        input = "!AIVDM,1,1,,B,<rOwUArW>mATsl8mEu6cvWeww1gsMlTPAh,4*62"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(12)
        expect(parsed.ais.repeat_indicator).to eq(3)
        expect(parsed.ais.source_mmsi).to eq(704636231)
        expect(parsed.ais.destination_mmsi).to eq(701420825)
        expect(parsed.ais.retransmit?).to eq(false)
        expect(parsed.ais.data).to eq(";4H5U=F+>'-??A/;]4$ QC")
      end

      it "properly decodes the armored payload libais #121" do
        input = "!AIVDM,1,1,,B,<wLRpfsG8c`kvsl,2*69"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(12)
        expect(parsed.ais.repeat_indicator).to eq(3)
        expect(parsed.ais.source_mmsi).to eq(1036564667) # TODO: 10 digits???
        expect(parsed.ais.destination_mmsi).to eq(902344332)
        expect(parsed.ais.retransmit?).to eq(true)
        expect(parsed.ais.data).to eq(">;M") # TODO: ??
      end

      it "properly decodes the armored payload libais #122" do
        input = "!AIVDM,1,1,2,A,<JCD;TFOAJ<sK5BUEtSnr3sGw7JL0n9iGcAcWDfh3@adi0=M;0g8735w@:Jwbh=N1ha0p4gaJlK1tFukvbolGN`05J1q?CPi7Se:R8prFvIddB3Tspje?n4P,1*4E"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(12)
        expect(parsed.ais.repeat_indicator).to eq(1)
        expect(parsed.ais.source_mmsi).to eq(691342225)
        expect(parsed.ais.destination_mmsi).to eq(668035278)
        expect(parsed.ais.retransmit?).to eq(true)
        expect(parsed.ais.data).to eq("[ER%U<#6:C;W?GZ\\@6I1W+Q+'T.0CP),1@M]K@/HGCE?PJZ?*0M^A0)@8D/)Z4[A<V=3>*74W^(@EZA9OS 1G#-J\"H8:V>Y,,RC$;82-O6DP")
      end

      it "properly decodes the armored payload libais #123" do
        input = "!AIVDM,1,1,0,A,<urwHv=la=:;A;j228:KwcgPM4N9qFDHwpLb;fO4Vj9w`Vq@?>;wBBs:,0*59"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(12)
        expect(parsed.ais.repeat_indicator).to eq(3)
        expect(parsed.ais.source_mmsi).to eq(934271224)
        expect(parsed.ais.destination_mmsi).to eq(489239714)
        expect(parsed.ais.retransmit?).to eq(true)
        expect(parsed.ais.text).to eq("QK2BBHJ[?+/ ]D^I9VTX?8\\*K._D&2I?(&9PONK?RR;J") # TODO: ???
      end

    end

    context "when dealing with VDM payload data message type 13" do
      it "properly decodes the armored payload libais #129" do
        input = "!AIVDM,1,1,,A,=aIlsw:<uhv:u90,2*72"
        parsed = @parser.parse(input)
        expect(parsed.ais.message_type).to eq(13)
        expect(parsed.ais.repeat_indicator).to eq(2)
        expect(parsed.ais.source_mmsi).to eq(631061500)
        expect(parsed.ais.ack1_mmsi).to eq(591250402)
        expect(parsed.ais.ack1_sequence_number).to eq(2)
        expect(parsed.ais.ack2_mmsi).to eq(62608)
        expect(parsed.ais.ack2_sequence_number).to eq(nil)
        expect(parsed.ais.ack3_mmsi).to eq(nil)
        expect(parsed.ais.ack3_sequence_number).to eq(nil)
        expect(parsed.ais.ack4_mmsi).to eq(nil)
        expect(parsed.ais.ack4_sequence_number).to eq(nil)
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
        expect(parsed.ais.dte_ready?).to eq(false)
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
