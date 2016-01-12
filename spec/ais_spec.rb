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

      class TestMessage < NMEAPlus::Message::AIS::VDMPayload::VDMMsg
        attr_accessor :source_mmsi
      end

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
