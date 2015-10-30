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
        expect(parsed.interpreted_data_type).to eq("GPGGA")
        expect(parsed.checksum).to eq("47")
        expect(parsed.checksum).to eq(parsed.calculated_checksum)
        expect(parsed.checksum_ok).to eq(true)
      end
    end

    context "when reading a message" do
      it "recognizes bad checksums" do
        input = "$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*48"
        parsed = @parser.parse(input)
        expect(parsed.calculated_checksum).to eq("47")
        expect(parsed.checksum_ok).to eq(false)
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
        expect(parsed.checksum_ok).to eq(true)
      end
    end
  end
end
