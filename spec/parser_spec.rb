require 'nmea_plus'

RSpec.describe NMEAPlus::Decoder, "#parse" do
  describe "testing the parser" do
    before do
      @parser = NMEAPlus::Decoder.new
    end

    context "when initialized" do
      it "can parse" do
        #puts "got these tokens: #{@parser.tokenize("$1,2*33")}"
        #@parser.parse("$1,2*33")
        #puts "got these tokens: #{@parser.tokenize("$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47")}"
        @parser.parse("$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47")
      end
    end

    context "when reading a message" do
      it "conforms to basic data storage requirements" do
        input = "$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47"
        parsed = @parser.parse(input)
        expect(parsed.original).to eq(input)
        expect(parsed.data_type).to eq("GPGGA")
        expect(parsed.interpreted_data_type).to eq("GGA")
        expect(parsed.checksum).to eq("47")
        expect(parsed.checksum).to eq(parsed.calculated_checksum)
        expect(parsed.checksum_ok?).to eq(true)
        expect(parsed.total_messages).to eq(1)
        expect(parsed.message_number).to eq(1)
        expect(parsed.all_messages_received?).to eq(true)
      end
    end

    context "when reading a message" do
      it "recognizes bad checksums" do
        input = "$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*48"
        parsed = @parser.parse(input)
        expect(parsed.calculated_checksum).to eq("47")
        expect(parsed.checksum_ok?).to eq(false)
      end
    end

    context "when reading a message" do
      it "recognizes multipart" do
        input = "$GPALM,3,1*00"
        parsed1 = @parser.parse(input)
        expect(parsed1.total_messages).to eq(3)
        expect(parsed1.message_number).to eq(1)
        expect(parsed1.all_messages_received?).to eq(false)

        input = "$GPALM,3,2*00"
        parsed2 = @parser.parse(input)
        expect(parsed2.total_messages).to eq(3)
        expect(parsed2.message_number).to eq(2)
        expect(parsed2.all_messages_received?).to eq(false)

        input = "$GPALM,3,3*00"
        parsed3 = @parser.parse(input)
        expect(parsed3.total_messages).to eq(3)
        expect(parsed3.message_number).to eq(3)
        expect(parsed3.all_messages_received?).to eq(false)

        parsed1.add_message_part(parsed2)
        expect(parsed1.all_messages_received?).to eq(false)
        parsed1.add_message_part(parsed3)
        expect(parsed1.all_messages_received?).to eq(true)
      end
    end

    context "when reading an NMEA message" do
      it "conforms to basic NMEA features" do
        input = "$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47"
        parsed = @parser.parse(input)
        expect(parsed.talker).to eq("GP")
        expect(parsed.message_type).to eq("GGA")
      end
    end

    context "when reading a GPGGA message" do
      it "properly reports various fields" do
        input = "$GPGGA,123519,4807.038,N,01131.000,W,1,08,0.9,545.4,M,46.9,M,2.2,123*4b"
        parsed = @parser.parse(input)
        now = Time.now
        expect(parsed.fix_time).to eq(Time.new(now.year, now.month, now.day, 12, 35, 19))
        expect(parsed.latitude).to eq(48.1173)
        expect(parsed.longitude).to eq(-11.516666666666666666)
        expect(parsed.fix_quality).to eq(1)
        expect(parsed.satellites).to eq(8)
        expect(parsed.horizontal_dilution).to eq(0.9)
        expect(parsed.altitude).to eq(545.4)
        expect(parsed.altitude_units).to eq("M")
        expect(parsed.geoid_height).to eq(46.9)
        expect(parsed.geoid_height_units).to eq("M")
        expect(parsed.seconds_since_last_update).to eq(2.2)
        expect(parsed.dgps_station_id).to eq("123")
        expect(parsed.checksum_ok?).to eq(true)
      end
    end

    context "when reading a GPAAM message" do
      it "properly reports various fields" do
        input = "$GPAAM,A,A,0.10,N,WPTNME*43"
        parsed = @parser.parse(input)
        expect(parsed.arrival_circle_entered?).to eq(true)
        expect(parsed.waypoint_passed?).to eq(true)
        expect(parsed.arrival_circle_radius).to eq(0.10)
        expect(parsed.arrival_circle_radius_units).to eq('N')
        expect(parsed.waypoint_id).to eq('WPTNME')
      end
    end


    context "when reading a GPALM message" do
      it "properly reports various fields" do
        input = "$GPALM,1,1,15,1159,00,441d,4e,16be,fd5e,a10c9f,4a2da4,686e81,58cbe1,0a4,001*5B"
        parsed = @parser.parse(input)
        expect(parsed.total_messages).to eq(1)
        expect(parsed.message_number).to eq(1)
        expect(parsed.satellite_prn).to eq(15)
        expect(parsed.gps_week).to eq(1159)
        expect(parsed.sv_health).to eq(0)
        expect(parsed.eccentricity).to eq(17437)
        expect(parsed.reference_time).to eq(78)
        expect(parsed.inclination_angle).to eq(5822)
        expect(parsed.ascension_rate).to eq(64862)
        expect(parsed.semimajor_axis_root).to eq(10554527)
        expect(parsed.perigee_argument).to eq(4861348)
        expect(parsed.ascension_node_longitude).to eq(6844033)
        expect(parsed.mean_anomaly).to eq(5819361)
        expect(parsed.f0_clock).to eq(164)
        expect(parsed.f1_clock).to eq(1)
      end
    end

    # context "when reading a  message" do
    #   it "properly reports various fields" do
    #     input = ""
    #     parsed = @parser.parse(input)
    #     expect(parsed.).to eq()
    #   end
    # end

  end
end
